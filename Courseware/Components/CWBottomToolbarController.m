//
//  CWBottomToolbarController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBottomToolbarController.h"
#import "CWNotesListViewController.h"
#import "CWEvaluationTestViewController.h"
#import "CWAppDelegate.h"

@interface CWBottomToolbarController ()

@property (nonatomic, strong) UIPopoverController *popOverController;
@property (nonatomic, strong) UINavigationController *notesNavController;
@property (nonatomic, strong) UINavigationController *bookmarksNavController;

@end

@implementation CWBottomToolbarController


- (void)bookmarksAction:(id)target
{
	if (!self.bookmarksNavController) {
		CWNotesListViewController *rootVC = [[CWNotesListViewController alloc] initWithStyle:UITableViewStylePlain];
		rootVC.title = @"Bookmarks";
		self.bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	}
	if (!self.popOverController) {
		self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.bookmarksNavController];
	}
	else {
		[self.popOverController setContentViewController:self.bookmarksNavController animated:NO];
	}
	[self.popOverController setPopoverContentSize:CGSizeMake(320, 480)];
	[self.popOverController presentPopoverFromBarButtonItem:target permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)notesAction:(id)target
{
	if (!self.notesNavController) {
		CWNotesListViewController *rootVC = [[CWNotesListViewController alloc] initWithStyle:UITableViewStylePlain];
		rootVC.title = @"Notes";
		self.notesNavController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	}
	if (!self.popOverController) {
		self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.notesNavController];
	}
	else {
		[self.popOverController setContentViewController:self.notesNavController animated:NO];
	}
	[self.popOverController setPopoverContentSize:CGSizeMake(320, 480)];
	[self.popOverController presentPopoverFromBarButtonItem:target permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)testsAction:(id)target
{
	UINavigationController *navController = [(CWAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	CWEvaluationTestViewController *vc = [[CWEvaluationTestViewController alloc] init];
	[navController pushViewController:vc animated:YES];
}

@end
