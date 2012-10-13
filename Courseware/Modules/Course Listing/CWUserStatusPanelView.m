//
//  CWUserStatusPanel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWUserStatusPanelView.h"
#import "CWUserStatusPanelController.h"

@interface CWUserStatusPanelView ()

@property (nonatomic, strong) CWUserStatusPanelController *controller;

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lblUsername;
@property (nonatomic, strong) IBOutlet UILabel *lblFullName;
@property (nonatomic, strong) IBOutlet UILabel *lblSchoolName;
@property (nonatomic, strong) IBOutlet UILabel *lblProgramName;

- (void)layoutNib;

@end

@implementation CWUserStatusPanelView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.controller = [[CWUserStatusPanelController alloc] init];
		[self layoutNib];
    }
    return self;
}

- (void)awakeFromNib
{
	self.controller = [[CWUserStatusPanelController alloc] init];
	[self layoutNib];
}

- (void)layoutNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWUserStatusPanelView" owner:self options:nil];
	[self addSubview:self.contentView];
	
	self.lblUsername.text = self.controller.getUserName;
	self.lblFullName.text = self.controller.getFullName;
	self.lblSchoolName.text = self.controller.getSchoolName;
	self.lblProgramName.text = self.controller.getProgramName;
}


@end
