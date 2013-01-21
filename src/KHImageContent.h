//
//  KHImageContent.h
//  PDFFiller
//
//  Created by Kim Hunter on 21/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray *KHImageContentInfo(CGSize size, UIColor *color);

@interface KHImageContent : NSObject

@property (assign) CGSize size;
@property (retain) UIColor *color;

- (UIImage *)image;
+ (id)contentWithArray:(NSArray *)array;

@end
