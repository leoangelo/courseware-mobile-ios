//
//  CWLibraryMediaSupport.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWLibraryMediaSupport : NSObject

@property (nonatomic, strong) NSString *filePath;

- (id)initWithFilePath:(NSString *)theFilePath;

- (NSString *)name;
- (UIImage *)previewIcon;
- (void)openPreview;

+ (NSSet *)supportedFileTypes;

@end
