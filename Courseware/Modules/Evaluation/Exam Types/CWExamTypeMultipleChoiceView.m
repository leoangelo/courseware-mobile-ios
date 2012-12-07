//
//  CWExamTypeMultipleChoiceView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamTypeMultipleChoiceView.h"
#import "CWExamTypeMultipleChoice.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@interface CWExamTypeMultipleChoiceView ()

@property (nonatomic, weak) CWExamTypeMultipleChoice *model;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UIButton *choice1Button;
@property (nonatomic, weak) IBOutlet UIButton *choice2Button;
@property (nonatomic, weak) IBOutlet UIButton *choice3Button;
@property (nonatomic, weak) IBOutlet UIButton *choice4Button;

- (IBAction)answerButtonHit:(id)sender;
- (void)updateButton:(UIButton *)theButton withTitle:(NSString *)theTitle;

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
		[self updateButton:self.choice1Button withTitle:[choices objectAtIndex:0]];
		[self updateButton:self.choice2Button withTitle:[choices objectAtIndex:1]];
		[self updateButton:self.choice3Button withTitle:[choices objectAtIndex:2]];
		[self updateButton:self.choice4Button withTitle:[choices objectAtIndex:3]];
		
		// follow the current theme
		self.questionLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
		self.questionLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	}
	return self;
}

- (void)updateButton:(UIButton *)theButton withTitle:(NSString *)theTitle
{
	[theButton setTitle:theTitle forState:UIControlStateNormal];
	theButton.titleLabel.numberOfLines = 0;
	theButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	theButton.titleLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:14]];
}

- (void)answerButtonHit:(id)sender
{
	[self.model studentSelectedChoice:[(UIButton *)sender titleForState:UIControlStateNormal]];
}

@end
