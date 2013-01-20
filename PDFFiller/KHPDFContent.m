//
//  KHPDFContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHPDFContent.h"
#import "KHPDFMaker.h"

@interface KHPDFContent ()
@property (retain, nonatomic) KHPDFMaker *pdfMaker;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) NSInteger pageCount;
@property (retain, nonatomic) NSArray *hotspots;
@end

@implementation KHPDFContent

- (void)dealloc
{
    self.pdfMaker = nil;
    [super dealloc];
}

+ (id)contentWithArray:(NSArray *)array
{
    NSAssert([array count] >= 2, @"Array must have this much stuff");
    NSAssert([array[0] isKindOfClass:[NSString class]], @"index 0 should contain a string of the page size");
    NSAssert([array[1] isKindOfClass:[NSNumber class]], @"index 1 should contain the number of pages");
    if ([array count] >= 3)
    {
        NSAssert([array[2] isKindOfClass:[NSArray class]], @"index 2 should contain hotspots");
    }
    
    KHPDFContent *content = [[KHPDFContent new] autorelease];
    content.size = CGSizeFromString(array[0]);
    content.pageCount = [array[1] integerValue];
    content.hotspots = array[2];
    return content;
}

- (NSString *)contentType
{
    return kKHContentTypePDF;
}

- (NSData *)dataForContent
{
    return [self.pdfMaker buildPDFWithSize:self.size pages:self.pageCount andHotspots:self.hotspots];
}

- (BOOL)writeToFile:(NSString *)fileName
{
    return [[self dataForContent] writeToFile:fileName atomically:YES];
}

#pragma mark - Optional

- (void)setPdfMaker:(KHPDFMaker *)pdfMaker
{
    self.pdfMaker = pdfMaker;
}

@end
