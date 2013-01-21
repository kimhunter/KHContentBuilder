//
//  UTKHContentBuilderTest.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "UTKHContentBuilderTest.h"
#import "KHContentBuilder.h"

@interface UTKHContentBuilderTest ()
@property (retain) KHContentBuilder *cb;
@property (retain) NSDictionary *contentDict;
@property (retain) NSFileManager *fm;
@end

@implementation UTKHContentBuilderTest

- (void)setUp
{
    if (self.fm == nil)
    {
        self.fm = [[NSFileManager new] autorelease];
    }
    self.cb = [[[KHContentBuilder alloc] initWithUniqueTmpBasePath] autorelease];
    self.contentDict = nil;
}

- (void)tearDown
{
    [self.fm removeItemAtPath:self.cb.basePath error:NULL];
    self.cb = nil;
}

#define KHIpadPortraitSize CGSizeMake(768.0, 1024.0)
#define KHIpadLandscapeSize CGSizeMake(1024.0, 768.0)

#define KHSizeString(W,H) NSStringFromCGSize(CGSizeMake((W), (H)))
#define KHIpadPortraitSizeString NSStringFromCGSize((KHIpadPortraitSize))
#define KHIpadLandscapeSizeString NSStringFromCGSize((KHIpadPortraitSize))

#define KHAssertFileExists(FilePath) STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:(FilePath)], nil)

- (BOOL)isDir:(NSString *)dirPath
{
	BOOL isDir = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
	return (exists && isDir) ? YES : NO;
}

- (void)testBuildSimple
{
    NSString *fileName = @"file.txt";
    NSString *content = @"This is the file";
    
    [_cb buildContent:@{fileName: KHTextContentInfoMake(content)}];
    NSString *fullPath = [_cb fullPathForRelPath:fileName];
    KHAssertFileExists(fullPath);
    NSString *fileContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:NULL];
    STAssertEqualObjects(fileContent, content, @"Content should be the same as we put in");
}

- (void)testBuildImage
{
    [_cb buildContent:@{@"one-png.png": KHImageContentInfo(CGSizeMake(50, 50), [UIColor blueColor]),
                        @"one-jpg.jpg": KHImageContentInfo(CGSizeMake(50, 50), [UIColor blueColor])}];
    
    KHAssertFileExists([_cb fullPathForRelPath:@"one-jpg.jpg"]);
    KHAssertFileExists([_cb fullPathForRelPath:@"one-png.png"]);
}

- (void)testBuildDir
{
    [_cb buildContent:@{@"dir/":@[]}];
    STAssertTrue([self isDir:[_cb fullPathForRelPath:@"dir/"]], @"Dir should exist");
}

- (void)testBuildAdvanced
{
    [_cb buildContent:@{@"20-Content/a.txt" : KHTextContentInfoMake(@"This is the file"),
                        @"30-Wow/P1-1.pdf"  : KHPDFContentInfoMake(KHIpadPortraitSize, 2, @[
                                                                   KHPDFHotspotMake(@"Map1", CGRectMake(100, 100, 400, 400), 1),
                                                                   KHPDFHotspotMake(@"Map2", CGRectMake(100, 400, 400, 400), 2),
                                                                   ]),
                        }];
    
    NSString *fullPath = [_cb fullPathForRelPath:@"20-Content/a.txt"];
    NSString *content = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:NULL];
    STAssertNotNil(content, nil);
    STAssertTrue([content hasPrefix:@"This"], nil);
    KHAssertFileExists([_cb fullPathForRelPath:@"30-Wow/P1-1.pdf"]);
}

- (void)testUseBlock
{
    [_cb addContentHandlerForExtensions:@[@"txt", @"rnd"] withBlock:^BOOL(NSString *fileName, NSArray *info) {
        return [(NSString *)info[0] writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }];
    
    [_cb buildContent:@{@"fileName.txt": KHTextContentInfoMake(@"Testing"),
                        @"fileName.rnd": KHTextContentInfoMake(@"Testing2"),
                        @"fileName.plist": @[@{@"test":@44444}], // built-in
                        @"ab.json":@[@{@"bbb": @4444}],          // built-in
    }];
    
    KHAssertFileExists([_cb fullPathForRelPath:@"fileName.txt"]);
    KHAssertFileExists([_cb fullPathForRelPath:@"fileName.rnd"]);
    KHAssertFileExists([_cb fullPathForRelPath:@"fileName.plist"]);
    KHAssertFileExists([_cb fullPathForRelPath:@"ab.json"]);
    

}

@end
