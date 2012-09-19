//
//  CWCourseDocumentView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/19/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReaderDocument;
@protocol CWCourseDocumentViewDataSource;
@protocol CWCourseDocumentViewDelegate;

@interface CWCourseDocumentView : UIScrollView

@property (nonatomic, assign) IBOutlet id<CWCourseDocumentViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<CWCourseDocumentViewDelegate> documentDelegate;

- (void)updateScrollViewContentViews;
- (void)showDocumentPage:(NSInteger)page;
- (void)showDocument:(id)object;

@end

@protocol CWCourseDocumentViewDataSource <NSObject>

- (ReaderDocument *)courseDocument;

@end

@protocol CWCourseDocumentViewDelegate <NSObject>

- (BOOL)areReaderControlsVisible;
- (void)makeReaderControlsVisible:(BOOL)visible animated:(BOOL)animated;

@end