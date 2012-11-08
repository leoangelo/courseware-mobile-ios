//
//  CWCourseReaderViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseReaderViewController.h"
#import "CWNavigationBar.h"
#import "CWBottomToolbar.h"
#import "SLSlideMenuView.h"
#import "ReaderDocument.h"
#import "CWCourseReaderModel.h"
#import "CWBrowserPaneView.h"
#import "CWCourseDocumentView.h"
#import "CWCourseItem.h"
#import "SLSlideMenuView.h"
#import "CWThemeHelper.h"

#pragma mark Constants

@interface CWCourseReaderViewController () <CWCourseDocumentViewDataSource, CWCourseDocumentViewDelegate, CWBrowserPaneViewDelegate, CWThemeDelegate, CWCourseReaderModelDelegate> {
	
	CWCourseReaderModel *model;
	CGSize lastAppearSize;
	
	NSDate *lastVisibilityToggleDate;
	BOOL isAnimating;
}

@property (nonatomic, weak) IBOutlet CWCourseDocumentView *documentView;
@property (nonatomic, weak) IBOutlet CWBrowserPaneView *browserPane;
@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet CWBottomToolbar *toolbar;
@property (nonatomic, strong) SLSlideMenuView *slideMenuView;

- (void)makeReaderControlsVisible:(BOOL)visible animated:(BOOL)animated;
- (BOOL)areReaderControlsVisible;
- (void)finishedVisibilityAnimation;

@end

@implementation CWCourseReaderViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		model = [[CWCourseReaderModel alloc] init];
		model.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.slideMenuView = [SLSlideMenuView slideMenuView];
	[self.slideMenuView attachToNavBar:self.navBar];
	[self makeReaderControlsVisible:YES animated:NO];
	[self.browserPane setActiveItem:model.selectedCourseItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.slideMenuView = nil;
	
	lastVisibilityToggleDate = nil;
	lastAppearSize = CGSizeZero;
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewWillAppear:animated];
	
	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
			[self.documentView updateScrollViewContentViews]; // Update content views
		}
		
		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
	
	[self updateFontAndColor];
}

- (void)viewDidAppear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewDidAppear:animated];
	
	if (CGSizeEqualToSize(self.documentView.contentSize, CGSizeZero)) // First time
	{
		[self.documentView performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
	}
	
#if (READER_DISABLE_IDLE == TRUE) // Option
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewWillDisappear:animated];
	
	lastAppearSize = self.view.bounds.size; // Track view size
	
#if (READER_DISABLE_IDLE == TRUE) // Option
	
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Custom Setters



- (void)setSelectedCourse:(CWCourseItem *)selectedCourse
{
	model.selectedCourseItem = selectedCourse;
	[self.browserPane setActiveItem:selectedCourse];
}

#pragma mark - Model delegate

- (void)modelChangedSelectedCourseItem:(CWCourseItem *)theNewItem
{
	[self.browserPane setActiveItem:theNewItem];
}

- (void)modelUpdateDisplayedDocument:(ReaderDocument *)theDocument
{
	[self.documentView performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
}

- (void)modelUpdateDisplayedDocumentPage:(NSUInteger)thePageNumber
{
	[self.documentView showDocumentPage:thePageNumber];
}

#pragma mark - Browser Pane

- (void)browser:(CWBrowserPaneView *)browser selectedItem:(CWCourseItem *)item
{
	model.selectedCourseItem = item;
}

#pragma mark - Document View Datasource

- (ReaderDocument *)courseDocument
{
	return model.courseDocument;
}

#pragma mark - Controls Visibility

- (void)makeReaderControlsVisible:(BOOL)visible animated:(BOOL)animated
{	
	if (lastVisibilityToggleDate && ([lastVisibilityToggleDate timeIntervalSinceNow] >= -0.75f)) {
		return;
	}
	
	if (animated) {
		// Do not do animation when already doing so.
		if (isAnimating) return;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration:0.25f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishedVisibilityAnimation)];
	}
	
	self.documentView.frame = (CGRect) {
		visible ? self.browserPane.frame.size.width : 0,
		self.documentView.frame.origin.y,
		self.documentView.frame.size
	};
	
	self.slideMenuView.alpha = visible ? 1.0f : 0.0f;
	
	self.navBar.alpha = visible ? 1.0f : 0.0f;
	self.navBar.frame = (CGRect) {
		self.navBar.frame.origin.x,
		visible ? 0 : -self.navBar.frame.size.height,
		self.navBar.frame.size
	};
	
	self.browserPane.alpha = visible ? 1.0f : 0.0f;
	self.browserPane.frame = (CGRect) {
		visible ? 0.0f : -self.browserPane.frame.size.width,
		self.browserPane.frame.origin.y,
		self.browserPane.frame.size
	};
	
	self.toolbar.alpha = visible ? 1.0f : 0.0f;
	self.toolbar.frame = (CGRect) {
		self.toolbar.frame.origin.x,
		visible ? self.view.frame.size.height - self.toolbar.frame.size.height : self.view.frame.size.height + self.toolbar.frame.size.height,
		self.toolbar.frame.size
	};
	
	if (animated) {
		isAnimating = YES;
		[UIView commitAnimations];
	}
	
	 lastVisibilityToggleDate = nil;
	lastVisibilityToggleDate = [NSDate date];
}

- (BOOL)areReaderControlsVisible
{
	return self.navBar.alpha != 0.f || self.browserPane.alpha != 0.f || self.toolbar.alpha != 0.f || self.slideMenuView.alpha != 0.f;
}

- (void)finishedVisibilityAnimation
{
	isAnimating = NO;
}

- (void)updateFontAndColor
{
	[self.toolbar updateFontAndColor];
}

@end
