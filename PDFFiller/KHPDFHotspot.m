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
    hs.fillWithColor = [UIColor grayColor];
    return hs;
}



- (void)addToContext:(CGContextRef)c withPageSize:(CGSize)pageSize
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
        CGContextSaveGState(c);
        CGContextScaleCTM(c, 1.0, -1.0);
        CGContextTranslateCTM(c, 0.0, -pageSize.height);

        CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, -1.0),CGAffineTransformMakeTranslation(0.0, pageSize.height));
        CGPDFContextSetURLForRect(c, url, CGRectApplyAffineTransform(self.rect, transform));
        CFRelease(url);

        if (self.fillWithColor != nil)
        {
            CGContextSetFillColorWithColor(c, [self.fillWithColor CGColor]);
            CGContextFillRect(c, self.rect);
        }
        CGContextRestoreGState(c);    }
}

@end
