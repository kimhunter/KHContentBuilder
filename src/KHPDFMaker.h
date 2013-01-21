//
//  KHPDFMaker.h
//  PDFFiller
//
//  Created by Kim Hunter on 19/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHPDFMaker : NSObject
- (NSData *)buildPDFWithSize:(CGSize)defaultSize pages:(NSInteger)pageCount andHotspots:(NSArray *)hotspots;
@end
