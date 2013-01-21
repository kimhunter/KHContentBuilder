//
//  KHContentBuilder.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHContent.h"
#import "KHDirContent.h"
#import "KHPDFHotspot.h"
#import "KHTextContent.h"
#import "KHPDFContent.h"
#import "KHPNGContent.h"
#import "KHJPGContent.h"

extern NSString *const kKHContentTypePDF;
extern NSString *const kKHContentTypeText;
extern NSString *const kKHContentTypeJPG;
extern NSString *const kKHContentTypePNG;
extern NSString *const kKHContentTypeDir;

/* Info Helpers */
NSArray *KHPlistContentInfo(id plistObject, NSPropertyListFormat fmt);
NSArray *KHJsonContentInfo(id plistObject);


//TODO: Add appledoc style comments to this class

@interface KHContentBuilder : NSObject

@property (retain) NSFileManager *fm;
@property (retain) NSString *basePath;
@property (nonatomic, readonly) KHPDFMaker *pdfMaker;

- (id)initWithBasePath:(NSString *)path;
- (id)initWithUniqueTmpBasePath;
- (NSString *)fullPathForRelPath:(NSString *)relPath;

- (void)addContentHandlerForExtensions:(NSArray *)extensions withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey;
- (void)addContentHandlerForExtensions:(NSArray *)extensions withBlock:(BOOL(^)(NSString *fileName, NSArray *info))block;
/** build a directory structure with the given dictionary
    @param fileDict dictionary of key(NSString)/values(NSArray)
                    The key is a path relative to the basePath
                    A key with a suffix of '/' denotes an empty directory
                    Use the correct array using KH()ContentInfoMake methods to return the correct array
                        these are simplified to take primative types
 */
- (void)buildContent:(NSDictionary *)fileDict;

+ (NSString *)uniqueKey;
@end
