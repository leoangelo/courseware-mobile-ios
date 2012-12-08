//
//  CWMessageDetailView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CWMessageDetailView.h"
#import "CWMessagingModel.h"
#import "CWMessage.h"
#import "CWConstants.h"
#import "SLTextInputAutoFocusHelper.h"

@interface CWMessageDetailView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *toTextField;
@property (nonatomic, weak) IBOutlet UITextField *fromTextField;
@property (nonatomic, weak) IBOutlet UITextField *subjectTextField;
@property (nonatomic, weak) IBOutlet UITextView *bodyTextView;

@property (nonatomic, weak) IBOutlet UILabel *toLabel;
@property (nonatomic, weak) IBOutlet UILabel *fromLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *textViewBg;

//+ (void)makeViewRounded:(UIView *)theView;
//+ (void)addShadowToView:(UIView *)theView;

@end

@implementation CWMessageDetailView

- (void)dealloc
{
	_model = nil;
}

- (void)awakeFromNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWMessageDetailView" owner:self options:nil];
	[self addSubview:self.contentView];
	
	self.textViewBg.image = [[UIImage imageNamed:@"Courseware.bundle/backgrounds/textview-bg.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
}

- (void)refreshView
{
	self.toTextField.text = self.model.selectedMessage.receiver_email;
	self.fromTextField.text = self.model.selectedMessage.sender_email;
	self.subjectTextField.text = self.model.selectedMessage.title;
	self.bodyTextView.text = self.model.selectedMessage.body;
	
	BOOL canEdit = [CWMessagingModel messageIsDrafted:self.model.selectedMessage];
	
	self.toTextField.enabled = canEdit;
	self.fromTextField.enabled = canEdit;
	self.subjectTextField.enabled = canEdit;
	self.bodyTextView.editable = canEdit;
}

- (void)preProcessMessage
{
	self.model.selectedMessage.sender_email = self.fromTextField.text;
	self.model.selectedMessage.receiver_email = self.toTextField.text;
	self.model.selectedMessage.title = self.subjectTextField.text;
	self.model.selectedMessage.body = self.bodyTextView.text;
}

- (void)updateFontAndColor
{
	UIFont *labelFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
	UIColor *labelColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES];

	self.toLabel.textColor = labelColor;
	self.fromLabel.textColor = labelColor;
	self.titleLabel.textColor = labelColor;
	
	self.toLabel.font = labelFont;
	self.fromLabel.font = labelFont;
	self.titleLabel.font = labelFont;
	
	self.toTextField.font = labelFont;
	self.fromTextField.font = labelFont;
	self.subjectTextField.font = labelFont;
	
	self.bodyTextView.font = labelFont;
}

- (void)beginAutoFocus
{
	[SLTextInputAutoFocusHelper beginAutoFocus];
}

- (void)stopAutoFocus
{
	[SLTextInputAutoFocusHelper stopAutoFocus];
}

@end
