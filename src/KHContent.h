//
//  KHContent.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KHPDFMaker;

@protocol KHContent <NSObject>
@required

/** returns an instance of your class based on the given meta data */
+ (id)contentWithArray:(NSArray *)array;

/** write the file out to this file name */
- (BOOL)writeToFile:(NSString *)fileName;


@optional
// only used by builtin pdftype so you can customize pdf info (coming)
- (void)setPdfMaker:(KHPDFMaker *)pdfMaker;

- (NSString *)contentType;
@end
