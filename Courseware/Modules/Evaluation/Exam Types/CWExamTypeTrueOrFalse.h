//
//  CWExamTypeTrueOrFalse.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWExamItemType.h"

@interface CWExamTypeTrueOrFalse : CWExamItemType

@property (nonatomic) BOOL isStatementTrue;

- (void)studentAnsweredTrue:(BOOL)isAnswerTrue;

@end
