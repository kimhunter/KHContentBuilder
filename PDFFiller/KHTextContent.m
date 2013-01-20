//
//  KHTextContent.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHTextContent.h"
#import "KHContentBuilder.h"

@interface KHTextContent ()
@property (retain, nonatomic) NSString *content;
@end

@implementation KHTextContent

+ (id)contentWithArray:(NSArray *)array
{
    NSAssert([array count] == 1, @"Array only accepts one item");
    KHTextContent *textContent = [[[self class] new] autorelease];
    textContent.content = array[0];
    return textContent;
}

- (BOOL)writeToFile:(NSString *)fileName
{
    NSError *error = nil;
    if (![self.content writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"Error Writing to file %@: %@", fileName, error);
        return NO;
    }
    return YES;
}

- (NSData *)dataForContent
{
    return [NSData dataWithBytes:[self.content UTF8String] length:self.content.length];
}

- (NSString *)contentType
{
    return kKHContentTypeText;
}

@end
