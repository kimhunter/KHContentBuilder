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
NSString *const kKHContentTypeJpeg = @"kKHContentTypeJpeg";
NSString *const kKHContentTypePNG = @"kKHContentTypeJpeg";

@interface KHContentBuilder ()
@property (nonatomic, retain) NSArray *supportedContentTypes;
@property (nonatomic, retain) NSDictionary *contentTypeMap;
@property (nonatomic, retain) KHPDFMaker *pdfMaker;
@end

@implementation KHContentBuilder

- (void)dealloc
{
    self.fm = nil;
    self.contentTypeMap = nil;
    self.supportedContentTypes = nil;
    self.pdfMaker = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
	{
        self.supportedContentTypes = @[
                                       kKHContentTypePDF,
                                       kKHContentTypeText,
                                       ];
        self.contentTypeMap = @{
                                @"txt": kKHContentTypeText,
                                @"pdf": kKHContentTypePDF,
                                };
        _pdfMaker = [[KHPDFMaker alloc] init];
		_fm = [[NSFileManager alloc] init];
    }
    return self;
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

- (void)createBasePath
{
    //TODO: Add error logging
	[_fm createDirectoryAtPath:self.basePath withIntermediateDirectories:YES attributes:nil error:NULL];
}

@end
