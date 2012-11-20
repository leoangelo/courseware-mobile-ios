//
//  CWExamTypeMultipleChoice.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamTypeMultipleChoice.h"
#import "CWExamTypeMultipleChoiceView.h"

@interface CWExamTypeMultipleChoice ()

@property (nonatomic, strong) CWExamTypeMultipleChoiceView *myView;

@end

@implementation CWExamTypeMultipleChoice

+ (id)mockQuestion
{
	CWExamTypeMultipleChoice *mockQ = [[CWExamTypeMultipleChoice alloc] init];
	mockQ.statement = @"The responsibility to ensure that cargo units are stowed and secured at all times in an efficient manner lies in the shoulder of the ________________.";
	mockQ.choices = @[@"Master", @"Chief Officer", @"Super Cargo", @"Loading Supervisor"];
	mockQ.correctChoice = @"Master";
	return mockQ;
}

+ (id)mockQuestion2
{
	CWExamTypeMultipleChoice *mockQ = [[CWExamTypeMultipleChoice alloc] init];
	mockQ.statement = @"In the segregation of packages containing incompatible dangerous goods and stowed in the conventional way, what is meant by “away from”?";
	mockQ.choices =
	@[@"a minimum horizontal separation of 3 meters when stowed on deck",
	@"a minimum horizontal separation of 6 meters when stowed on deck",
	@"a minimum horizontal separation of 12 meters when stowed on deck",
	@"a minimum horizontal separation of 24 meters when stowed on deck"];
	mockQ.correctChoice = @"a minimum horizontal separation of 3 meters when stowed on deck";
	return mockQ;
}

+ (id)mockQuestion3
{
	CWExamTypeMultipleChoice *mockQ = [[CWExamTypeMultipleChoice alloc] init];
	mockQ.statement = @"The dangerous cargo manifest does NOT indicate __________.";
	mockQ.choices =
	@[@"the stowage location of hazardous material on board the vessel",
	@"a description of the packaging(drums, boxes etc.)",
	@"the net weight of each hazardous cargo",
	@"UN identification number"];
	mockQ.correctChoice = @"the net weight of each hazardous cargo";
	return mockQ;
}

+ (id)mockQuestion4
{
	CWExamTypeMultipleChoice *mockQ = [[CWExamTypeMultipleChoice alloc] init];
	mockQ.statement = @"What is meant by segregation of cargoes?";
	mockQ.choices =
	@[@"Separating cargoes by destination",
	@"Listing cargoes in order of their flammability",
	@"Classifying cargoes according to their toxicity",
	@"Separating cargoes so one cannot damage the other"];
	mockQ.correctChoice = @"Separating cargoes so one cannot damage the other";
	return mockQ;
}

+ (id)mockQuestion5
{
	CWExamTypeMultipleChoice *mockQ = [[CWExamTypeMultipleChoice alloc] init];
	mockQ.statement = @"What is the difference between the static and dynamic forces acting on the ship’s hull?";
	mockQ.choices =
	@[@"Static forces are set up by the sea motion, and dynamic forces are set up by the cargo in a moving sea",
	@"Static forces are by the sea and cargo, and dynamic forces are set up by the movement of the cargo at sea",
	@"Static forces are set up by the cargo and the sea, and dynamic forces are set up by the sea wave action",
	@"Static forces are set up by the cargo only, and dynamic forces are set up by the sea motion."];
	mockQ.correctChoice = @"Static forces are set up by the cargo and the sea, and dynamic forces are set up by the sea wave action";
	return mockQ;
}

- (UIView *)getView
{
	return self.myView;
}

- (CWExamTypeMultipleChoiceView *)myView
{
	if (!_myView) {
		_myView = [[CWExamTypeMultipleChoiceView alloc] initWithModel:self];
	}
	return _myView;
}

- (void)studentSelectedChoice:(NSString *)theSelected
{
	self.score = [theSelected isEqualToString:self.correctChoice] ? 1.f : 0.f;
	[self.delegate examItemDidFinishAnswering:self];
}

@end
