//
//  KHPDFHotspot.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KHPDFHotspotMake(S, Rect, Page) [KHPDFHotspot hotspotWithString:(S) withRect:(Rect) onPage:(Page)]

@interface KHPDFHotspot : NSObject
@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) NSInteger page;
@property (retain, nonatomic) NSString *urlString;
@property (assign, nonatomic) BOOL shouldEscapeAndAddHttpIfMissing;
@property (retain, nonatomic) UIColor *fillWithColor;


- (void)addToContext:(CGContextRef)c withPageSize:(CGSize)pageSize;
+ (id)hotspotWithString:(NSString *)urlString withRect:(CGRect)hsRect onPage:(NSInteger)page;

@end
