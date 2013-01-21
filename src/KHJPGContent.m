//
//  KHJpegContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 21/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHJPGContent.h"

@implementation KHJPGContent

- (BOOL)writeToFile:(NSString *)fileName
{
    UIImage *image = [self image];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    return [data writeToFile:fileName atomically:YES];
}

@end
