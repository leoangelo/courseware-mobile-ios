//
//  CWCourseReaderModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReaderDocument;
@class CWCourseItem;
@protocol CWCourseReaderModelDelegate <NSObject>

- (void)modelChangedSelectedCourseItem:(CWCourseItem *)theNewItem;
- (void)modelUpdateDisplayedDocument:(ReaderDocument *)theDocument;
- (void)modelUpdateDisplayedDocumentPage:(NSUInteger)thePageNumber;

@end

@interface CWCourseReaderModel : NSObject

@property (nonatomic, weak) id<CWCourseReaderModelDelegate> delegate;
@property (nonatomic, strong, readonly) ReaderDocument *courseDocument;
@property (nonatomic, strong) CWCourseItem *selectedCourseItem;

@property (nonatomic, strong, readonly) NSString *documentPath;
@property (nonatomic, readonly) NSUInteger pageNumber;

+ (ReaderDocument *)documentFromFilePath:(NSString *)filePath;
- (void)openFile:(NSString *)filePath page:(NSInteger)pageNumber;

@end
