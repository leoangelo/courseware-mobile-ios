//
//  CWExamTypeTrueOrFalseView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamTypeTrueOrFalseView.h"
#import "CWExamTypeTrueOrFalse.h"
#import "CWConstants.h"

@interface CWExamTypeTrueOrFalseView ()

@property (nonatomic, weak) CWExamTypeTrueOrFalse *model;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UIButton *trueButton;
@property (nonatomic, weak) IBOutlet UIButton *falseButton;

- (IBAction)answerButtonHit:(id)sender;

@end

@implementation CWExamTypeTrueOrFalseView

- (id)initWithModel:(CWExamTypeTrueOrFalse *)theModel
{
	self = [super init];
	if (self) {
		
		_model = theModel;
		
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
		
		CGRect selfRect = self.frame;
		selfRect.size = self.contentView.bounds.size;
		self.frame = selfRect;
		
		[self addSubview:self.contentView];
		
		self.questionLabel.text = self.model.statement;
	}
	return self;
}

- (void)answerButtonHit:(id)sender
{
	if (sender == self.trueButton) {
		[self.model studentAnsweredTrue:YES];
	}
	else if (sender == self.falseButton) {
		[self.model studentAnsweredTrue:NO];
	}
}

@end
