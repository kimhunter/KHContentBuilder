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
//+ (id)contentWithDictionary:(NSDictionary *)dict;
+ (id)contentWithArray:(NSArray *)array;

- (NSString *)contentType;
- (BOOL)writeToFile:(NSString *)fileName;
- (NSData *)dataForContent;

@optional
- (void)setPdfMaker:(KHPDFMaker *)pdfMaker;
@end
