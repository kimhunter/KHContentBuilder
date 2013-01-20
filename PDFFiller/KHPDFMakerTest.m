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

}

@end
