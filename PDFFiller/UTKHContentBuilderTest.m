//
//  UTKHContentBuilderTest.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "UTKHContentBuilderTest.h"
#import "KHContentBuilder.h"
#import "KHPDFHotspot.h"

@interface UTKHContentBuilderTest ()
@property KHContentBuilder *cb;
@end

@implementation UTKHContentBuilderTest

- (void)setUp
{
    NSString *basePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[KHContentBuilder uniqueKey]];
    self.cb = [[KHContentBuilder alloc] initWithBasePath:basePath];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:self.cb.basePath error:NULL];
    self.cb = nil;
}

#define KHSizeString(W,H) NSStringFromCGSize(CGSizeMake((W), (H)))
#define KHIpadPortraitSize KHSizeString(768.0, 1024.0)
#define KHPDFHotspotMake(S, Rect, Page) [KHPDFHotspot hotspotWithString:(S) withRect:(Rect) onPage:(Page)]

- (void)testBuildSimple
{
    [self.cb buildContent:@{
                            @"20-Content/a.txt" : @[@"This is the file"],
                            @"30-Wow/P1-1.pdf"  : @[KHIpadPortraitSize,
                                                    @2,
                                                    @[
                                                        KHPDFHotspotMake(@"Map1", CGRectMake(100, 100, 400, 400), 1),
                                                        KHPDFHotspotMake(@"Map2", CGRectMake(100, 400, 400, 400), 2),
                                                     ]
                                                  ],
        }];
    
    NSString *fullPath = [self.cb.basePath stringByAppendingPathComponent:@"20-Content/a.txt"];
    NSString *content = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@", fullPath);
    STAssertNotNil(content, nil);
    STAssertTrue([content hasPrefix:@"This"], nil);
}

@end
