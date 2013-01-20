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
extern NSString *const kKHContentTypeDir;

@interface KHContentBuilder : NSObject

@property (retain) NSFileManager *fm;
@property (retain) NSString *basePath;

- (id)initWithBasePath:(NSString *)path;
- (NSString *)fullPathForRelPath:(NSString *)relPath;

/** build a directory structure with the given dictionary
    @param fileDict dictionary of key(NSString)/values(NSArray)
                    The key should is a path relative to the basePath
                    A key with a suffix of '/' denotes an empty directory
                    Use the correct array using KH()ContentInfoMake methods to return the correct array
                        these are simplified to take primative types
 */
- (void)buildContent:(NSDictionary *)fileDict;

+ (NSString *)uniqueKey;
@end
