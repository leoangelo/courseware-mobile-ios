//
//  CWEvaluationResultsView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationResultsView.h"
#import "CWEvaluationResultsController.h"
#import "CWConstants.h"

@interface CWEvaluationResultsView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *remarkContentView;
@property (nonatomic, weak) IBOutlet UIView *reviewMistakesContentView;

@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
@property (nonatomic, weak) IBOutlet UIImageView *remarkBackground;
@property (nonatomic, weak) IBOutlet UIButton *reviewMistakesButton;
@property (nonatomic, weak) IBOutlet UIButton *exitButton1;

@property (nonatomic, weak) IBOutlet UITableView *mistakesTableView;
@property (nonatomic, weak) IBOutlet UIButton *exitButton2;

- (IBAction)reviewMistakesPressed:(id)sender;
- (IBAction)exitButtonPressed:(id)sender;

- (void)updateRemarkViewContent;
- (void)updateReviewMistakesViewContent;

@end

@implementation CWEvaluationResultsView

- (void)dealloc
{
	_myController = nil;
}

- (id)initWithController:(CWEvaluationResultsController *)theController
{
	self = [super init];
	if (self) {
		self.myController = theController;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
		
		[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
		
		[self addSubview:self.remarkContentView];
		[self addSubview:self.reviewMistakesContentView];
		
		self.remarkContentView.hidden = YES;
		self.reviewMistakesContentView.hidden = YES;
	}
	return self;
}

- (void)showInView:(UIView *)theView
{
	self.frame = (CGRect) {
		CGPointZero,
		theView.frame.size
	};
	
	[self updateRemarkViewContent];
	[self updateReviewMistakesViewContent];
	
	// the remark view is initially displayed;
	self.remarkContentView.hidden = NO;
	
	self.alpha = 0.f;
	[self removeFromSuperview];
	[theView addSubview:self];
	
	[UIView animateWithDuration:0.3 animations:^{
		self.alpha = 1.f;
	}];
}

- (void)updateRemarkViewContent
{
	self.remarkContentView.frame = (CGRect) {
		roundf((self.frame.size.width - self.remarkContentView.frame.size.width) / 2.f),
		roundf((self.frame.size.height - self.remarkContentView.frame.size.height) / 2.f),
		self.remarkContentView.frame.size
	};
	NSString *remarkTextFmt = nil;
	if (self.myController.hasPassed) {
		remarkTextFmt = @"You have passed with a score of %d%%";
	}
	else {
		remarkTextFmt = @"You have failed with a score of %d%%";
	}
	self.remarkLabel.text = [NSString stringWithFormat:remarkTextFmt, (int)(self.myController.score * 100.f)];
	
	self.reviewMistakesButton.hidden = self.myController.hasPassed;
	self.exitButton1.hidden = !self.reviewMistakesButton.hidden;
}

- (void)updateReviewMistakesViewContent
{
	self.reviewMistakesContentView.frame = (CGRect) {
		roundf((self.frame.size.width - self.reviewMistakesContentView.frame.size.width) / 2.f),
		roundf((self.frame.size.height - self.reviewMistakesContentView.frame.size.height) / 2.f),
		self.reviewMistakesContentView.frame.size
	};
	[self.mistakesTableView reloadData];
}

- (void)reviewMistakesPressed:(id)sender
{
	[self switchToMistakesView:YES];
}

- (void)switchToMistakesView:(BOOL)toMistakes
{
	self.remarkContentView.hidden = toMistakes;
	self.reviewMistakesContentView.hidden = !toMistakes;
}

- (void)exitButtonPressed:(id)sender
{
	[self.myController.delegate exitEvaluation];
}

#pragma mark - Table view

- (UIFont *)mistakeItemFont
{
	return [UIFont fontWithName:kGlobalAppFontNormal size:17];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.myController.mistakes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.myController.mistakes objectAtIndex:indexPath.row] sizeWithFont:[self mistakeItemFont] constrainedToSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellId = @"mistake-cell";
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (!aCell) {
		aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
		aCell.textLabel.numberOfLines = 0;
		aCell.textLabel.font = [self mistakeItemFont];
		aCell.textLabel.textColor = [UIColor whiteColor];
		aCell.textLabel.textAlignment = UITextAlignmentCenter;
	}
	aCell.textLabel.text = [NSString stringWithFormat:@"%i) %@", indexPath.row + 1, [self.myController.mistakes objectAtIndex:indexPath.row]];
	return aCell;
}

@end
