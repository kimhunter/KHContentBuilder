
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
	

Your class must adopt the `<KHContent>` protocol
	
    - (void)addContentHandlerForExtensions:(NSArray *)extensions withClass:(Class<KHContent>)cls withTypeKey:(NSString *)typeKey;

    [contentBuilder addContentHandlerForExtensions:@[@"gif"] withClass:[CustomGifContent class] withTypeKey:@"gifContentKey"];
    [contentBuilder buildContent:@{ @"gif" : @[/*some info here that your class will know how to create*/] }];



