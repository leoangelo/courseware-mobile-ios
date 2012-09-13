//
//  CWCourseListFileLoader.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWCourse;
@protocol CWCourseListFileLoaderDelegate;

@interface CWCourseListFileLoader : NSObject

@property (nonatomic, assign) id<CWCourseListFileLoaderDelegate> loaderDelegate;

- (id)initWithDelegate:(id<CWCourseListFileLoaderDelegate>)theDelegate;
- (void)loadFilePath:(NSString *)theFilePath;
- (void)loadSampleFile;

@end

@protocol CWCourseListFileLoaderDelegate <NSObject>

@optional
- (void)loader:(CWCourseListFileLoader *)theLoader coursePrepared:(CWCourse *)theCourse;
- (void)loaderFinished:(CWCourseListFileLoader *)theLoader;

@end
