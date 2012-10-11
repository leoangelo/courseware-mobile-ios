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

@property (nonatomic, retain) CWUserStatusPanelController *controller;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblUsername;
@property (nonatomic, retain) IBOutlet UILabel *lblFullName;
@property (nonatomic, retain) IBOutlet UILabel *lblSchoolName;
@property (nonatomic, retain) IBOutlet UILabel *lblProgramName;

- (void)layoutNib;

@end

@implementation CWUserStatusPanelView

- (void)dealloc
{
	[_imgAvatar release];
	[_lblUsername release];
	[_lblFullName release];
	[_lblSchoolName release];
	[_lblProgramName release];
	[_contentView release];
	[_controller release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.controller = [[[CWUserStatusPanelController alloc] init] autorelease];
		[self layoutNib];
    }
    return self;
}

- (void)awakeFromNib
{
	self.controller = [[[CWUserStatusPanelController alloc] init] autorelease];
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
