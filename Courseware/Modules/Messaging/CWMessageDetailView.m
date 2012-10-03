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

@interface CWMessageDetailView ()

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIToolbar *actionToolbar;
@property (nonatomic, retain) IBOutlet UITextField *toTextField;
@property (nonatomic, retain) IBOutlet UITextField *fromTextField;
@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;

- (void)updateActionToolbar;

- (NSArray *)actionSetForDrafts;
- (NSArray *)actionSetForInbox;
- (NSArray *)actionSetForSent;
- (NSArray *)actionSetForTrash;

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)actionSelector;

@end

@implementation CWMessageDetailView

- (void)dealloc
{
	_model = nil;
	[_actionToolbar release];
	[_toTextField release];
	[_fromTextField release];
	[_subjectTextField release];
	[_bodyTextView release];
	[_contentView release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWMessageDetailView" owner:self options:nil];
	[self addSubview:self.contentView];
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
	return [[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self.model action:actionSelector] autorelease];
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

@end
