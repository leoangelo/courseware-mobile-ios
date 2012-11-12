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
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *lastDateRead;

+ (void)openPreview:(NSString *)fullFilePath;

- (id)initWithFilePath:(NSString *)theFilePath dateRead:(NSDate *)lastDateRead;

- (NSString *)name;
- (UIImage *)previewIcon;
- (void)openPreview;

+ (NSSet *)supportedFileTypes;

@end
