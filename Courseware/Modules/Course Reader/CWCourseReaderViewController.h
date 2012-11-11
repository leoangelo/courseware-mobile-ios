//
//  CWCourseReaderViewController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWCourseItem;

@interface CWCourseReaderViewController : UIViewController

- (void)setSelectedCourse:(CWCourseItem *)theCourseItem;

- (NSString *)currentDocumentPath;
- (NSInteger)currentDocumentPage;

- (void)openFile:(NSString *)filePath page:(NSInteger)pageNumber;

@end
