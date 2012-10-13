//
//  CWCourseReaderModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReaderDocument;

@interface CWCourseReaderModel : NSObject

@property (nonatomic, strong) ReaderDocument *courseDocument;

- (NSInteger)randomPageIndex;

+ (ReaderDocument *)documentFromFilePath:(NSString *)filePath;
+ (ReaderDocument *)sampleDocument;

@end
