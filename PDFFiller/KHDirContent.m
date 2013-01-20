//
//  KHDirContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHDirContent.h"
#import "KHContentBuilder.h"

@implementation KHDirContent
+ (id)contentWithArray:(NSArray *)array
{
    return [[[self class] new] autorelease];
}

- (NSData *)dataForContent
{
    return nil;
}

- (NSString *)contentType
{
    return kKHContentTypeDir;
}

- (BOOL)writeToFile:(NSString *)fileName
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:fileName
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:NULL];
}

@end
