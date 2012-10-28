//
//  CWMessageToolbar.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/28/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessageToolbar.h"
#import "CWMessagingModel.h"

@interface CWMessageToolbar ()

- (void)updateActionToolbar;

- (NSArray *)actionSetForDrafts;
- (NSArray *)actionSetForInbox;
- (NSArray *)actionSetForSent;
- (NSArray *)actionSetForTrash;
- (NSArray *)actionSetForMessageList;

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)actionSelector;

@end

@implementation CWMessageToolbar

- (void)awakeFromNib
{
	[self setBackgroundImage:[UIImage imageNamed:@"Courseware.bundle/backgrounds/blank-bg.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)updateActionToolbar
{
	NSArray *actionSetToUse = nil;
	if (self.model.selectedMessage == nil) {
		actionSetToUse = [self actionSetForMessageList];
	}
	else if ([CWMessagingModel messageIsTrashed:self.model.selectedMessage]) {
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
	
	self.items = actionSetToUse;
}

- (NSArray *)actionSetForMessageList
{
	return [NSArray arrayWithObjects:
			[self itemWithTitle:@"Mark as Read" action:@selector(markAsReadAction)],
			[self itemWithTitle:@"Delete" action:@selector(deleteAction)],
			nil];
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

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(SEL)actionSelector
{
	NSString *iconFileName = nil;
	if ([title isEqualToString:@"Delete"] || [title isEqualToString:@"Discard"]) {
		iconFileName = @"Courseware.bundle/controls/email/delete-icon.png";
	}
	else if ([title isEqualToString:@"Reply"]) {
		iconFileName = @"Courseware.bundle/controls/email/reply-icon.png";
	}
	else if ([title isEqualToString:@"Forward"]) {
		iconFileName = @"Courseware.bundle/controls/email/forward-icon.png";
	}
	else if ([title isEqualToString:@"Mark as Read"]) {
		iconFileName = @"Courseware.bundle/controls/email/mark-read-icon.png";
	}
	else if ([title isEqualToString:@"Send"]) {
		iconFileName = @"Courseware.bundle/controls/email/send-icon.png";
	}
	else if ([title isEqualToString:@"Save"]) {
		iconFileName = @"Courseware.bundle/controls/email/save-icon.png";
	}
	UIImage *iconImage = [UIImage imageNamed:iconFileName];
	if (iconImage) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn addTarget:self.model action:actionSelector forControlEvents:UIControlEventTouchUpInside];
		[btn setImage:iconImage forState:UIControlStateNormal];
		[btn sizeToFit];
		return [[UIBarButtonItem alloc] initWithCustomView:btn];
	}
	return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self.model action:actionSelector];
}

@end
