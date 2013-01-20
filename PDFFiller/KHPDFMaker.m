//
//  KHPDFMaker.m
//  PDFFiller
//
//  Created by Kim Hunter on 19/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "KHPDFMaker.h"
#import "KHPDFHotspot.h"

static size_t KHPDFMaker_dataConsumerPutBytes
(
    void *info,
    const void *buffer,
    size_t count)
{
	CFMutableDataRef data = (CFMutableDataRef)info;
	CFDataAppendBytes(data, buffer, count);
	return count;
}

static void KHPDFMaker_dataConsumerReleaseInfo
(
    void *info)
{
	CFMutableDataRef pdfData = (CFMutableDataRef)info;
	CFRelease(pdfData);
	return;
}

static CGDataConsumerCallbacks const dataConsumerCallbacks = {  KHPDFMaker_dataConsumerPutBytes, KHPDFMaker_dataConsumerReleaseInfo};

static CGDataConsumerRef KHPDFMaker_dataConsumerCreate
(
    void)
{
	CFMutableDataRef info = CFDataCreateMutable(kCFAllocatorDefault, 0);
	CGDataConsumerRef dataConsumer = CGDataConsumerCreate((void *)info, &dataConsumerCallbacks);
	if (dataConsumer == nil)
	{
		CFRelease(info);
	}
	return dataConsumer;
}

@implementation KHPDFMaker
- (NSString *)uniqueKey
{
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
	CFRelease(uuidRef);
	NSString *uuid = (NSString *)stringRef;
	return [uuid autorelease];
}

- (void)build
{
    
    KHPDFHotspot *hs = [KHPDFHotspot hotspotWithString:@"this is my test" withRect:CGRectMake(20.0, 20.0, 70.0, 70.0) onPage:1];
    KHPDFHotspot *hs1 = [KHPDFHotspot hotspotWithString:@"this is my test" withRect:CGRectMake(20.0, 20.0, 70.0, 20.0) onPage:2];

    NSData *pdfData = [self buildPDFWithSize:CGSizeMake(100, 100) pages:3 andHotspots:@[hs, hs1]];
    [pdfData writeToFile:@"/Users/kim/Desktop/Test.pdf" atomically:YES];
}

- (NSData *)buildPDFWithSize:(CGSize)defaultSize pages:(NSInteger)pageCount andHotspots:(NSArray *)hotspots
{
    CGRect mediaBox = CGRectZero;
    mediaBox.size = defaultSize;

    CFMutableDataRef pdfData = CFDataCreateMutable(kCFAllocatorDefault, 0);
    
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData(pdfData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, NULL);
    CGDataConsumerRelease(dataConsumer);

    for (int i = 1; i <= pageCount; ++i)
    {
        CGPDFContextBeginPage(pdfContext, NULL);
        NSArray *pageHotspots = [hotspots filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"page = %d", i]];

        for (KHPDFHotspot *hotspot in pageHotspots)
        {
            [hotspot addToContext:pdfContext withPageSize:mediaBox.size];
        }
        
        CGPDFContextEndPage(pdfContext);
        pageHotspots = nil;
    }
	
    CGPDFContextClose(pdfContext);
	CGContextRelease(pdfContext);
    
    NSData *returnData = [[(NSData *)pdfData retain] autorelease];
    CFRelease(pdfData);
    return returnData;
}
@end