//
//  CWUserStatusPanel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWUserStatusPanelView.h"
#import "CWUserStatusPanelController.h"
#import "CWConstants.h"

@interface CWUserStatusPanelView ()

@property (nonatomic, strong) CWUserStatusPanelController *controller;

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel *lblUsername;
@property (nonatomic, weak) IBOutlet UILabel *lblFullName;
@property (nonatomic, weak) IBOutlet UILabel *lblSchoolName;
@property (nonatomic, weak) IBOutlet UILabel *lblProgramName;

@property (nonatomic, weak) IBOutlet UILabel *lblStatisticsTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblApproved;
@property (nonatomic, weak) IBOutlet UILabel *lblBlocked;
@property (nonatomic, weak) IBOutlet UILabel *lblFailed;
@property (nonatomic, weak) IBOutlet UILabel *lblApprovedValue;
@property (nonatomic, weak) IBOutlet UILabel *lblBlockedValue;
@property (nonatomic, weak) IBOutlet UILabel *lblFailedValue;

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

- (void)updateFontAndColor
{
	self.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	
	UIColor *textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	UIFont *headerFonts = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:28]];
	UIFont *userDetailFonts = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	UIFont *statisticsFonts = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:14]];
	
	self.lblUsername.font = headerFonts;
	self.lblUsername.textColor = textColor;
	self.lblFullName.font = userDetailFonts;
	self.lblFullName.textColor = textColor;
	self.lblSchoolName.font = userDetailFonts;
	self.lblSchoolName.textColor = textColor;
	self.lblProgramName.font = userDetailFonts;
	self.lblProgramName.textColor = textColor;
	
	self.lblStatisticsTitle.font = headerFonts;
	self.lblStatisticsTitle.textColor = textColor;
	self.lblApproved.font = statisticsFonts;
	self.lblApproved.textColor = textColor;
	self.lblApprovedValue.font = statisticsFonts;
	self.lblApprovedValue.textColor = textColor;
	self.lblBlocked.font = statisticsFonts;
	self.lblBlocked.textColor = textColor;
	self.lblBlockedValue.font = statisticsFonts;
	self.lblBlockedValue.textColor = textColor;
	self.lblFailed.font = statisticsFonts;
	self.lblFailed.textColor = textColor;
	self.lblFailedValue.font = statisticsFonts;
	self.lblFailedValue.textColor = textColor;
}


@end
