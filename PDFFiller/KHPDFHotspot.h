//
//  KHPDFHotspot.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHPDFHotspot : NSObject
@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) NSInteger page;
@property (retain, nonatomic) NSString *urlString;
@property (assign, nonatomic) BOOL shouldEscapeAndAddHttpIfMissing;


- (void)addToContext:(CGContextRef)c;
+ (id)hotspotWithString:(NSString *)urlString withRect:(CGRect)hsRect onPage:(NSInteger)page;

@end
