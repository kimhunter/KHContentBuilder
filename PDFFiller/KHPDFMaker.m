//
//  KHPDFMaker.m
//  PDFFiller
//
//  Created by Kim Hunter on 19/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHPDFMaker.h"
#import <CoreGraphics/CoreGraphics.h>

static size_t KHPDFMaker_dataConsumerPutBytes(void *info, const void *buffer, size_t count)
{
    CFMutableDataRef data = (CFMutableDataRef)info;
    CFDataAppendBytes(data, buffer, count);
    return count;
}

static void KHPDFMaker_dataConsumerReleaseInfo(void* info)
{
    CFMutableDataRef pdfData = (CFMutableDataRef) info;
    CFRelease(pdfData);
    return;
}

static CGDataConsumerCallbacks const dataConsumerCallbacks = {	KHPDFMaker_dataConsumerPutBytes,KHPDFMaker_dataConsumerReleaseInfo};

static CGDataConsumerRef KHPDFMaker_dataConsumerCreate(void)
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
    NSString *uuid = [(NSString *)stringRef autorelease];
    return uuid;
}

- (void)build
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[self uniqueKey]];
    filePath = @"/Users/kim/Desktop/test.pdf";
    CGContextRef pdfContext;
    CGRect mediaBox = CGRectMake(0.0, 0.0, 768.0, 1024.0);
    NSLog(@"%@", NSStringFromCGRect(mediaBox));
    //    CGDataConsumerRef dataConsumer = KHPDFMaker_dataConsumerCreate();
    //    pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, NULL);
    //    CGDataConsumerRelease(dataConsumer);

    pdfContext = CGPDFContextCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], &mediaBox, NULL);
    void *mBox = (void *)&mediaBox;
    CGPDFContextBeginPage(pdfContext,(CFDictionaryRef)@{(id)kCGPDFContextMediaBox: (id)CFDataCreate(NULL, mBox, sizeof(CGRect))});
    CGContextSetFillColorWithColor(pdfContext, [[UIColor redColor] CGColor]);
    CGContextFillRect(pdfContext, CGRectInset(mediaBox, 20, 20));
    CGPDFContextEndPage(pdfContext);
    
    CGPDFContextClose(pdfContext);
    CGContextRelease(pdfContext);
    
}


@end
