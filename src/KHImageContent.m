//
//  KHImageContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 21/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHImageContent.h"

NSArray *KHImageContentInfo(CGSize size, UIColor *color)
{
    return @[NSStringFromCGSize(size), color];
}

@implementation KHImageContent

+ (id)contentWithArray:(NSArray *)array
{
    KHImageContent *content = nil;
    if ([array count] >= 1)
    {
        content = [[[self class] new] autorelease];
        content.size = CGSizeFromString(array[0]);
        
        if ([array count] > 1 && [array[1] isKindOfClass:[UIColor class]])
        {
            content.color = array[1];
        }
        else
        {
            content.color = [UIColor redColor];
        }
    }
    
    return content;
}

- (UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, self.size.width, self.size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
