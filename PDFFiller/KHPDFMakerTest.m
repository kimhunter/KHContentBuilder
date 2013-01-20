//
//  KHPDFMakerTest.m
//  PDFFiller
//
//  Created by Kim Hunter on 19/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHPDFMakerTest.h"
#import "KHPDFMaker.h"

@interface KHPDFMakerTest ()
@property (nonatomic, retain) KHPDFMaker *pdfMaker;
@end

@implementation KHPDFMakerTest
- (void)setUp
{
	self.pdfMaker = [[[KHPDFMaker alloc] init] autorelease];
	[_pdfMaker build];
}

- (void)testWhat
{
    CFURLRef url = NULL;
    NSURL *nUrl = nil;
    NSString *str = [@"this is a test" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    nUrl = [NSURL URLWithString:str relativeToURL:[NSURL URLWithString:@"http://"]];

//    url = CFURLCreateWithBytes(NULL, "this is a test", strlen("this is a test"), NSUTF8StringEncoding, NULL);
////     = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)@"this is a test", NULL);
    if (url)
    {
        NSLog(@"url = %@", (id)url);
        CFRelease(url);
    }
    if (nUrl)
    {
        NSLog(@"nUrl = %@", (id)nUrl);
    }

}

@end
