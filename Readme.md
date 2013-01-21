
KHContentBuilder is designed for creating file/directory structures with meaningful data, both simply and easily. 

It's extendable, so you can create your own Content writers. 

## Sample Usage just add more keys/Values for more files


		NSString *basePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[KHContentBuilder uniqueKey]];
		KHContentBuilder *contentBuilder = [[KHContentBuilder alloc] initWithBasePath:basePath];
		[contentBuilder buildContent:@{@"thisdir/File.txt: KHTextContentInfoMake(content)}];
		
    

###Extend to write your own content types

Just implement 2 methods and you can have a custom content writer


    @protocol KHContent <NSObject>
    @required
    + (id)contentWithArray:(NSArray *)array;
    - (BOOL)writeToFile:(NSString *)fileName;

    @optional
    - (NSString *)contentType;
    - (void)setPdfMaker:(KHPDFMaker *)pdfMaker;
    @end
	

Or even easier use a block

    [cb addContentHandlerForExtensions:@[@"plist"] withBlock:^BOOL(NSString *fileName, NSArray *info) {
        return [(NSDictionary *)info[0] writeToFile:fileName atomically:YES];
    }];
    
Or even an plist example that takes a format as well as the object `@[@{}, @(NSPropertyListXMLFormat_v1_0)]`

    [cb addContentHandlerForExtensions:@[@"plist"] withBlock:^BOOL(NSString *fileName, NSArray *info) {
        NSDictionary *d = info[0];
        NSPropertyListFormat plFormat = NSPropertyListXMLFormat_v1_0;
        
        if ([info count] > 1)
        {
            plFormat = [(NSNumber *)info[1] unsignedIntegerValue];
        }
        
        NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        [outputStream open];
        [NSPropertyListSerialization writePropertyList:d 
                                              toStream:outputStream 
                                                format:NSPropertyListBinaryFormat_v1_0 
                                               options:nil
                                                 error:NULL];
        [outputStream close];
        return YES;
    }];
    

Your class must adopt the `<KHContent>` protocol
	
    - (void)addContentHandlerForExtensions:(NSArray *)extensions withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey;

    [contentBuilder addContentHandlerForExtensions:@[@"gif"] withClass:[CustomGifContent class] withTypeKey:@"gifContentKey"];
    [contentBuilder buildContent:@{ @"gif" : @[/*some info here that your class will know how to create*/] }];



