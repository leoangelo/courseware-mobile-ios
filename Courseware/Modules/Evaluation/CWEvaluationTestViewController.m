//
//  CWEvaluationTestViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationTestViewController.h"
#import "CWNavigationBar.h"
#import "CWEvaluationTestModel.h"
#import "CWExamItemType.h"
#import "CWEvaluationResultsController.h"

static NSInteger const kQuestionContentTag = 10;

@interface CWEvaluationTestViewController () <CWEvaluationTestModelDelegate, CWEvaluationResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet UIView *questionContainer;
@property (nonatomic, strong) CWEvaluationTestModel *testModel;
@property (nonatomic, strong) CWEvaluationResultsController *resultsController;

- (void)updateDisplayedQuestion;

@end

@implementation CWEvaluationTestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_testModel = [[CWEvaluationTestModel alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateDisplayedQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDisplayedQuestion
{
	UIView *displayedQuestionView = [self.questionContainer viewWithTag:kQuestionContentTag];
	UIView *viewToDisplay = [[self.testModel currentQuestion] getView];
	
	if (displayedQuestionView != viewToDisplay) {
		[displayedQuestionView removeFromSuperview];
		
		[viewToDisplay setTag:kQuestionContentTag];
		[self.questionContainer addSubview:viewToDisplay];
		
		viewToDisplay.frame = (CGRect) {
			roundf((self.questionContainer.frame.size.width - viewToDisplay.frame.size.width) / 2.f),
			roundf((self.questionContainer.frame.size.height - viewToDisplay.frame.size.height) / 2.f),
			viewToDisplay.frame.size
		};
	}
}

#pragma mark - Evaluation delegate

- (void)exitEvaluation
{
	[self.navigationController popViewControllerAnimated:YES];
};

#pragma mark - Model delegate

- (void)displayedQuestionNeedsUpdate
{
	[self updateDisplayedQuestion];
}

- (void)evaluationFinishedPassed:(BOOL)hasPassed score:(CGFloat)theScore mistakes:(NSArray *)mistakes
{
	if (!self.resultsController) {
		self.resultsController = [[CWEvaluationResultsController alloc] init];
		self.resultsController.delegate = self;
	}
	
	self.resultsController.hasPassed = hasPassed;
	self.resultsController.score = theScore;
	self.resultsController.mistakes = mistakes;
	
	[self.resultsController.getView showInView:self.questionContainer];
}

@end
