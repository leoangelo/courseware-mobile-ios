//
//  CWExamTypeMultipleChoiceView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamTypeMultipleChoiceView.h"
#import "CWExamTypeMultipleChoice.h"

@interface CWExamTypeMultipleChoiceView ()

@property (nonatomic, weak) CWExamTypeMultipleChoice *model;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UIButton *choice1Button;
@property (nonatomic, weak) IBOutlet UIButton *choice2Button;
@property (nonatomic, weak) IBOutlet UIButton *choice3Button;
@property (nonatomic, weak) IBOutlet UIButton *choice4Button;

- (IBAction)answerButtonHit:(id)sender;

@end

@implementation CWExamTypeMultipleChoiceView

- (id)initWithModel:(CWExamTypeMultipleChoice *)theModel
{
	self = [super init];
	if (self) {
		_model = theModel;
		
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
		CGRect selfRect = self.frame;
		selfRect.size = self.contentView.bounds.size;
		self.frame = selfRect;
		
		[self addSubview:self.contentView];
		
		NSAssert(_model.choices.count == 4, @"must be 4 choices");
		
		self.questionLabel.text = _model.statement;
		
		NSArray *choices = _model.choices;
		[self.choice1Button setTitle:[choices objectAtIndex:0] forState:UIControlStateNormal];
		[self.choice2Button setTitle:[choices objectAtIndex:1] forState:UIControlStateNormal];
		[self.choice3Button setTitle:[choices objectAtIndex:2] forState:UIControlStateNormal];
		[self.choice4Button setTitle:[choices objectAtIndex:3] forState:UIControlStateNormal];
		
		self.questionLabel.numberOfLines = 0;
		self.choice1Button.titleLabel.numberOfLines = 0;
		self.choice2Button.titleLabel.numberOfLines = 0;
		self.choice3Button.titleLabel.numberOfLines = 0;
		self.choice4Button.titleLabel.numberOfLines = 0;
		
		self.choice1Button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.choice2Button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.choice3Button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.choice4Button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	}
	return self;
}

- (void)answerButtonHit:(id)sender
{
	[self.model studentSelectedChoice:[(UIButton *)sender titleForState:UIControlStateNormal]];
}

@end
