//
//  CWMessageDetailView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessageDetailView.h"

@interface CWMessageDetailView ()

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIToolbar *actionToolbar;
@property (nonatomic, retain) IBOutlet UITextField *toTextField;
@property (nonatomic, retain) IBOutlet UITextField *fromTextField;
@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;

@end

@implementation CWMessageDetailView

- (void)dealloc
{
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


@end
