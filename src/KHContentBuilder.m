//
//  KHContentBuilder.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHContentBuilder.h"
#import "KHPDFMaker.h"

NSString *const kKHContentTypePDF = @"kKHContentTypePDF";
NSString *const kKHContentTypeText = @"kKHContentTypeText";
NSString *const kKHContentTypeJPG = @"kKHContentTypeJPG";
NSString *const kKHContentTypePNG = @"kKHContentTypePNG";
NSString *const kKHContentTypeDir = @"kKHContentTypeDir";
NSString *const kKHContentBlock   = @"kKHContentBlock";

@interface KHContentBuilder ()
@property (nonatomic, retain) NSMutableDictionary *contentTypeMap;
@property (nonatomic, retain) NSMutableDictionary *contentClassMap;
@property (nonatomic, retain) NSMutableDictionary *contentBlockMap;
@property (nonatomic, retain) KHPDFMaker *pdfMaker;
@end

@implementation KHContentBuilder

- (void)dealloc
{
    self.fm = nil;
    self.pdfMaker = nil;
    self.contentTypeMap = nil;
    self.contentClassMap = nil;
    self.contentBlockMap = nil;
    [super dealloc];
}

- (id)initWithBasePath:(NSString *)path
{
    self = [self init];
    if (self)
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
        self.contentTypeMap  = [NSMutableDictionary dictionary];
        self.contentClassMap = [NSMutableDictionary dictionary];
        self.contentBlockMap = [NSMutableDictionary dictionary];
		
        self.fm = [[[NSFileManager alloc] init] autorelease];

        [self addContentHandlerForExtensions:nil withClass:[KHDirContent class] withTypeKey:kKHContentTypeDir];
        [self addContentHandlerForExtensions:@[@"pdf"] withClass:[KHPDFContent class] withTypeKey:kKHContentTypePDF];
        [self addContentHandlerForExtensions:@[@"png"] withClass:[KHPNGContent class] withTypeKey:kKHContentTypePNG];
        [self addContentHandlerForExtensions:@[@"jpg",@"jpeg"] withClass:[KHJPGContent class] withTypeKey:kKHContentTypeJPG];
        
        [self addContentHandlerForExtensions:@[@"txt", @"html", @"htm", @"css", @"url",]
                                   withClass:[KHTextContent class]
                                 withTypeKey:kKHContentTypeText];
    }
    return self;
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

- (BOOL)canMakeWithBlock:(NSString *)filePath
{
    BOOL isBlockType = [[self contentTypeForFileName:filePath] isEqualToString:kKHContentBlock];
    return isBlockType;
}

// Write content object to disk
- (void)makeContentFile:(NSString *)filePath withArrayInfo:(NSArray *)info
{
    id<KHContent> content = [self contentForPath:filePath withInfo:info];

    if ([content respondsToSelector:@selector(setPdfMaker:)])
    {
        [content setPdfMaker:self.pdfMaker];
    }
    
    NSString *fullPath = [self fullPathForRelPath:filePath];
    [_fm createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent]
   withIntermediateDirectories:YES
                    attributes:nil
                         error:NULL];
    
    if (content == nil && [self canMakeWithBlock:filePath])
    {
        BOOL (^contentBlock)(NSString *,NSArray *) = self.contentBlockMap[filePath.pathExtension.lowercaseString];
        if (contentBlock)
        {
            contentBlock(fullPath, info);
        }
    }
    else
    {
        [content writeToFile:fullPath];
    }
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

- (void)addContentHandlerForExtensions:(NSArray *)extensions withBlock:(BOOL(^)(NSString *fileName, NSArray *info))block
{
    for (NSString *ext in extensions)
    {
        self.contentTypeMap[[ext lowercaseString]] = kKHContentBlock;
        self.contentBlockMap[[ext lowercaseString]] = block;
    }
}

- (void)addContentHandlerForExtensions:(NSArray *)extensions withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey
{
    self.contentClassMap[typeKey] = cls;
    for (NSString *ext in extensions)
    {
        self.contentTypeMap[[ext lowercaseString]] = typeKey;
    }
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
