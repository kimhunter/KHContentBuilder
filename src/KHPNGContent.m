//
//  KHPNGContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 21/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHPNGContent.h"

@implementation KHPNGContent

- (BOOL)writeToFile:(NSString *)fileName
{
    NSData *data = UIImagePNGRepresentation([self image]);
    return [data writeToFile:fileName atomically:YES];
}

@end
