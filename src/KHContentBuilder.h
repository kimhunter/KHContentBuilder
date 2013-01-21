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

/*! Content Builder class */
@interface KHContentBuilder : NSObject

@property (retain) NSFileManager *fm;
@property (retain) NSString *basePath;
@property (nonatomic, readonly) KHPDFMaker *pdfMaker;

/*! @name Initialization */

/*! 
  Initialise with a base path
  @param path the base path that will be created and used for all relative names
 */
- (id)initWithBasePath:(NSString *)path;

/*! 
  Initialise with a unique directory in the respective temorary folder
  @param path the base path that will be created and used for all relative names
 */
- (id)initWithUniqueTmpBasePath;

/*! @name Custom Handlers */
/*! 
 Add a handler class for particular extensions
 
  @param extensions array of file extensions the extensions are case insensitive and will be lower cased
  @param cls        Class of the custom content handler adopting the <KHContent> protocol
  @param typeKey    A unique key for lookups of the content type
 */
- (void)addContentHandlerForExtensions:(NSArray *)extensions withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey;

/*!
  Add a block handler for extensions
    
  @param extensions array of file extensions the extensions are case insensitive and will be lower cased`
  @param block      a block which takes the full file path and the info array and performs the task of writing the content to disk for this particular file type
 */
- (void)addContentHandlerForExtensions:(NSArray *)extensions withBlock:(BOOL(^)(NSString *fileName, NSArray *info))block;

/*! @name Path Building */

/*! Get the full path of the relative path by prepending the base path
 
 @param relPath relative path for
 @return base path with the relative path appended
 */
- (NSString *)fullPathForRelPath:(NSString *)relPath;

/*! @name Building Content */
/*!
  build a directory structure with the given dictionary
  @param fileDict dictionary of key(NSString)/values(NSArray)  The key is a path relative to the basePath A key with a suffix of '/' denotes an empty directory Use the correct array using KH()ContentInfoMake methods to return the correct array these are simplified to take primative types
 */
- (void)buildContent:(NSDictionary *)fileDict;

/*! @name Class methods */

/*! make me a new UUID 
    @return an autoreleased UUID string
 */
+ (NSString *)uniqueKey;
@end
