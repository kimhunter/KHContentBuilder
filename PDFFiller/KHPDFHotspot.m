//
//  KHPDFHotspot.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHPDFHotspot.h"

@implementation KHPDFHotspot
- (void)dealloc
{
    self.urlString = nil;
    [super dealloc];
}

+ (id)hotspotWithString:(NSString *)urlString withRect:(CGRect)hsRect onPage:(NSInteger)page
{
    KHPDFHotspot *hs = [[[KHPDFHotspot alloc] init] autorelease];
    hs.urlString = urlString;
    hs.rect = hsRect;
    hs.page = page;
    hs.shouldEscapeAndAddHttpIfMissing = YES;
    return hs;
}


- (void)addToContext:(CGContextRef)c
{
    CFURLRef url = NULL;
    CFStringRef string = NULL;
    
    url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)self.urlString, NULL);
    if (url == NULL && self.shouldEscapeAndAddHttpIfMissing)
    {
        string = (CFStringRef) [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = CFURLCreateWithString(kCFAllocatorDefault, string, NULL);
    }

    if (url != NULL)
    {
        CGContextFillRect(c, self.rect);
        CGPDFContextSetURLForRect(c, url, self.rect);
        CFRelease(url);
    }
}

@end
