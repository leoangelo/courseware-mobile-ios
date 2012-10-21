//
//  CWMessageDetailView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessageDetailView.h"
#import "CWMessagingModel.h"
#import "CWMessage.h"
#import "CWConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface CWMessageDetailView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIToolbar *actionToolbar;
@property (nonatomic, weak) IBOutlet UITextField *toTextField;
@property (nonatomic, weak) IBOutlet UITextField *fromTextField;
@property (nonatomic, weak) IBOutlet UITextField *subjectTextField;
@property (nonatomic, weak) IBOutlet UITextView *bodyTextView;

@property (nonatomic, weak) IBOutlet UILabel *toLabel;
@property (nonatomic, weak) IBOutlet UILabel *fromLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *textViewBg;

- (void)updateActionToolbar;

- (NSArray *)actionSetForDrafts;
- (NSArray *)actionSetForInbox;
- (NSArray *)actionSetForSent;
- (NSArray *)actionSetForTrash;

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)actionSelector;

+ (void)makeViewRounded:(UIView *)theView;
+ (void)addShadowToView:(UIView *)theView;

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
	
	[self updateActionToolbar];
}

- (void)updateActionToolbar
{
	NSArray *actionSetToUse = nil;
	if ([CWMessagingModel messageIsTrashed:self.model.selectedMessage]) {
		actionSetToUse = [self actionSetForTrash];
	}
	else if ([CWMessagingModel messageIsSent:self.model.selectedMessage]) {
		actionSetToUse = [self actionSetForSent];
	}
	else if ([CWMessagingModel messageIsDrafted:self.model.selectedMessage]) {
		actionSetToUse = [self actionSetForDrafts];
	}
	else {
		actionSetToUse = [self actionSetForInbox];
	}
	
	self.actionToolbar.items = actionSetToUse;
}

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)actionSelector
{
	return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self.model action:actionSelector];
}

- (NSArray *)actionSetForDrafts
{
	return [NSArray arrayWithObjects:
			[self itemWithTitle:@"Send" action:@selector(sendAction)],
			[self itemWithTitle:@"Save" action:@selector(saveAction)],
			[self itemWithTitle:@"Discard" action:@selector(discardAction)],
			nil];
}

- (NSArray *)actionSetForInbox
{
	return [NSArray arrayWithObjects:
			[self itemWithTitle:@"Reply" action:@selector(replyAction)],
			[self itemWithTitle:@"Forward" action:@selector(forwardAction)],
			[self itemWithTitle:@"Delete" action:@selector(deleteAction)],
			nil];
}

- (NSArray *)actionSetForSent
{
	return [NSArray arrayWithObjects:
			[self itemWithTitle:@"Forward" action:@selector(forwardAction)],
			[self itemWithTitle:@"Delete" action:@selector(deleteAction)],
			nil];
}

- (NSArray *)actionSetForTrash
{
	return [NSArray arrayWithObjects:
			[self itemWithTitle:@"Restore" action:@selector(restoreAction)],
			[self itemWithTitle:@"Delete" action:@selector(deleteAction)],
			nil];
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

+ (void)makeViewRounded:(UIView *)theView
{
	theView.layer.masksToBounds = YES;
	theView.layer.cornerRadius = 8.f;
}

+ (void)addShadowToView:(UIView *)theView
{
	theView.layer.shadowColor = [UIColor blackColor].CGColor;
	theView.layer.shadowOpacity = 1.f;
	theView.layer.shadowOffset = CGSizeMake(0, -2);
	theView.layer.shadowRadius = 1;
}

@end
