//
//  KHContentBuilder.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHContentBuilder.h"
#import "KHPDFMaker.h"
#import "KHContent.h"
#import "KHPDFContent.h"
#import "KHTextContent.h"
#import "KHDirContent.h"


NSString *const kKHContentTypePDF = @"kKHContentTypePDF";
NSString *const kKHContentTypeText = @"kKHContentTypeText";
NSString *const kKHContentTypeJpeg = @"kKHContentTypeJpeg";
NSString *const kKHContentTypePNG = @"kKHContentTypeJpeg";
NSString *const kKHContentTypeDir = @"kKHContentTypeDir";

@interface KHContentBuilder ()
@property (nonatomic, retain) NSMutableDictionary *contentTypeMap;
@property (nonatomic, retain) NSMutableDictionary *contentClassMap;
@property (nonatomic, retain) KHPDFMaker *pdfMaker;
@end

@implementation KHContentBuilder

- (void)dealloc
{
    self.fm = nil;
    self.pdfMaker = nil;
    self.contentTypeMap = nil;
    self.contentClassMap = nil;
    [super dealloc];
}

- (id)initWithBasePath:(NSString *)path
{
    if ([self init])
    {
        self.basePath = path;
        [self createBasePath];
    }
    return self;
}


- (id)init
{
    self = [super init];
    if (self)
	{
        _contentTypeMap = [[self builtinTypeMap] mutableCopy];
        _contentClassMap = [[self builtinClassMap] mutableCopy];
		_fm = [[NSFileManager alloc] init];
    }
    return self;
}

- (NSDictionary *)builtinTypeMap
{
    return @{
             @"pdf" : kKHContentTypePDF,
             @"txt" : kKHContentTypeText,
             @"html": kKHContentTypeText,
             @"htm" : kKHContentTypeText,
             @"css" : kKHContentTypeText,
             @"url" : kKHContentTypeText,

             // below not supported yet
             @"png" : kKHContentTypePNG,
             @"jpg" : kKHContentTypeJpeg,
             @"jpeg": kKHContentTypeJpeg,
            };
}

- (NSDictionary *)builtinClassMap
{
    return @{ // add here when the type is supported
             kKHContentTypePDF : [KHPDFContent class],
             kKHContentTypeText: [KHTextContent class],
             kKHContentTypeDir : [KHDirContent class],
            };
}


- (void)createBasePath
{
    //TODO: Add error logging
	[_fm createDirectoryAtPath:self.basePath withIntermediateDirectories:YES attributes:nil error:NULL];
}

- (NSString *)contentTypeForFileName:(NSString *)path
{
    // path should only be the relative to basepath, as appending to basepath will strip trailing slash.
    if ([path hasSuffix:@"/"])
    {
        return kKHContentTypeDir;
    }
    NSString *ext = [[path pathExtension] lowercaseString];
    return self.contentTypeMap[ext];
}

// return the content object fo ra particular path
- (id<KHContent>)contentForPath:(NSString *)path withInfo:(NSArray *)info
{
    NSString *contentType = [self contentTypeForFileName:path];
    if (contentType)
    {
        return [self.contentClassMap[contentType] contentWithArray:(info)];
    }
    return nil;
}

// Write content object to disk
- (void)makeContentFile:(NSString *)filePath withArrayInfo:(NSArray *)info
{
    id<KHContent> content = [self contentForPath:filePath withInfo:info];

    if ([content respondsToSelector:@selector(setPdfMaker:)])
    {
        [content setPdfMaker:self.pdfMaker];
    }
    
    NSString *fullPath = [self.basePath stringByAppendingPathComponent:filePath];
    [_fm createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent]
   withIntermediateDirectories:YES
                    attributes:nil
                         error:NULL];
    [content writeToFile:fullPath];

}

- (KHPDFMaker *)pdfMaker
{
    if (_pdfMaker == nil)
    {
        self.pdfMaker = [[[KHPDFMaker alloc] init] autorelease];
    }
    return _pdfMaker;
}

#pragma mark - Public Methods

- (void)buildContent:(NSDictionary *)fileDict
{
    for (NSString *key in [fileDict allKeys])
    {
        NSString *file = key;
        NSArray *info = fileDict[key];
        [self makeContentFile:file withArrayInfo:info];
    }
}

- (NSString *)fullPathForRelPath:(NSString *)relPath
{
    return [self.basePath stringByAppendingPathComponent:relPath];
}

- (void)addContentHandlerForExtension:(NSString *)ext withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey;
{
    self.contentClassMap[typeKey] = cls;
    self.contentTypeMap[[ext lowercaseString]] = typeKey;
}


#pragma mark - Class Methods
+ (NSString *)uniqueKey
{
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
	CFRelease(uuidRef);
	NSString *uuid = (NSString *)stringRef;
	return [uuid autorelease];
}

@end
