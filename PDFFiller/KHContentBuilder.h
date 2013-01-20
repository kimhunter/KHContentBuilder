//
//  KHContentBuilder.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kKHContentTypePDF;
extern NSString *const kKHContentTypeText;
extern NSString *const kKHContentTypeJpeg;
extern NSString *const kKHContentTypePNG;

@interface KHContentBuilder : NSObject

@property (retain) NSFileManager *fm;
@property (retain) NSString *basePath;

@end
