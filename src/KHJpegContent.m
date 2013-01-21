//
//  KHJpegContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 21/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHJpegContent.h"

@implementation KHJpegContent

- (BOOL)writeToFile:(NSString *)fileName
{
    UIImage *image = [self image];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    return [data writeToFile:fileName atomically:YES];
}

@end
