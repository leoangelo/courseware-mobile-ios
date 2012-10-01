//
//  CWMessagingModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CWMessagingModelDelegate <NSObject>

- (void)mainMenuSelectedItemChanged;

@end

@interface CWMessagingModel : NSObject

@property (nonatomic, assign) id<CWMessagingModelDelegate> delegate;

- (void)refreshData;
- (NSArray *)mainMenuList;
- (NSArray *)messageListForCurrentSelection;
- (void)mainMenuItemSelected:(NSUInteger)index;

@end
