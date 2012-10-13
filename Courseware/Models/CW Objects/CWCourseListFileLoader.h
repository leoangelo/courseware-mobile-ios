//
//  CWCourseListFileLoader.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWCourseItem;
@protocol CWCourseListFileLoaderDelegate;

@interface CWCourseListFileLoader : NSObject

@property (nonatomic, weak) id<CWCourseListFileLoaderDelegate> loaderDelegate;

- (id)initWithDelegate:(id<CWCourseListFileLoaderDelegate>)theDelegate;
- (void)loadFilePath:(NSString *)theFilePath;
- (void)loadSampleFile;

@end

@protocol CWCourseListFileLoaderDelegate <NSObject>

@optional
- (void)loader:(CWCourseListFileLoader *)theLoader coursePrepared:(CWCourseItem *)theCourse;
- (void)loaderFinished:(CWCourseListFileLoader *)theLoader;

@end
