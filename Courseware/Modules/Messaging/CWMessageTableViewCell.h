//
//  CWMessageTableViewCell.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/28/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMessageTableViewCellIdentifierLight;
extern NSString * const kMessageTableViewCellIdentifierDark;

@protocol CWMessageTableViewCellDelegate;

@interface CWMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL unread;
@property (nonatomic, weak) id<CWMessageTableViewCellDelegate> delegate;

- (void)drawContentView:(CGRect)r;
- (void)layoutControls;

@end

@protocol CWMessageTableViewCellDelegate <NSObject>

- (void)checkButtonPressed:(CWMessageTableViewCell *)target;

@end