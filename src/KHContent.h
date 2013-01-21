//
//  KHContent.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KHPDFMaker;

/*! Protocol for Content Handler classes */
@protocol KHContent <NSObject>
@required

/*! 
    an instance of your class based on the given meta data
    @param array info array
    @return an instance of this class
 */
+ (id)contentWithArray:(NSArray *)array;

/*! 
    write the file out to this file name 
    @param fileName the fullpath on disk
    @return YES on success
 */
- (BOOL)writeToFile:(NSString *)fileName;


@optional
// only used by builtin pdftype so you can customize pdf info (coming)
- (void)setPdfMaker:(KHPDFMaker *)pdfMaker;

- (NSString *)contentType;
@end
