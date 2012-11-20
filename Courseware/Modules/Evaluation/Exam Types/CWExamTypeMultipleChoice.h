//
//  CWExamTypeMultipleChoice.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamItemType.h"

@interface CWExamTypeMultipleChoice : CWExamItemType

@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) NSString *correctChoice;

- (void)studentSelectedChoice:(NSString *)theSelected;

@end
