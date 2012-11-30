//
//  CWInterstitialAdsView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWInterstitialAdsView.h"
#import "CWUtilities.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

static NSInteger const kAdTimerLabelTag = 10;

@interface CWInterstitialAdsView ()

@property (nonatomic, weak) UIView *parentView;

- (void)updateAdLayout;
- (void)willAppear;
- (void)didAppear;
- (void)willDisappear;
- (void)didDisappear;

- (void)closeButtonPressed;

@end

@implementation CWInterstitialAdsView

- (void)updateAdLayout
{
	NSAssert(self.parentView != nil, @"Parent view must not be nil!");
	
	self.frame = self.parentView.bounds;
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UIView *overlayView = [[UIView alloc] initWithFrame:self.bounds];
	overlayView.backgroundColor = [self.delegate adsOverlayColor:self];
	[self addSubview:overlayView];
	
	UIImageView *imageToDisplay = [[UIImageView alloc] initWithImage:[self.delegate adsImage:self]];
	imageToDisplay.frame = (CGRect) {
		roundf((self.frame.size.width - imageToDisplay.frame.size.width) / 2.f),
		roundf((self.frame.size.height - imageToDisplay.frame.size.height) / 2.f),
		imageToDisplay.frame.size
	};
	[self addSubview:imageToDisplay];
	
	UILabel *lblAdTimer = [[UILabel alloc] init];
	lblAdTimer.text = @"";
	lblAdTimer.textAlignment = UITextAlignmentCenter;
	lblAdTimer.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	lblAdTimer.backgroundColor = [UIColor clearColor];
	lblAdTimer.textColor = [UIColor whiteColor];
	lblAdTimer.frame = (CGRect) {
		0,
		CGRectGetMaxY(imageToDisplay.frame),
		self.frame.size.width,
		30
	};
	lblAdTimer.tag = kAdTimerLabelTag;
	[self addSubview:lblAdTimer];
	
	if ([self.delegate adTitle:self]) {
		UILabel *aLbl = [[UILabel alloc] init];
		aLbl.text = [self.delegate adTitle:self];
		aLbl.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:24]];
		aLbl.backgroundColor = [UIColor clearColor];
		aLbl.textColor = [UIColor whiteColor];
		[aLbl sizeToFit];
		aLbl.frame = (CGRect) {
			roundf((self.frame.size.width - aLbl.frame.size.width) / 2.f),
			imageToDisplay.frame.origin.y - aLbl.frame.size.height,
			aLbl.frame.size
		};
		[self addSubview:aLbl];
	}
	
	if ([self.delegate adsisCloseable:self]) {
		UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[aBtn setImage:[UIImage imageNamed:@"Courseware.bundle/controls/interstitial-close.png"] forState:UIControlStateNormal];
		[aBtn setImage:[UIImage imageNamed:@"Courseware.bundle/controls/interstitial-close-on.png"] forState:UIControlStateHighlighted];
		[aBtn addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[aBtn sizeToFit];
		
		aBtn.frame = (CGRect) {
			CGRectGetMaxX(imageToDisplay.frame) - roundf(aBtn.frame.size.width * 0.5f),
			imageToDisplay.frame.origin.y - roundf(aBtn.frame.size.height * 0.5f),
			aBtn.frame.size
		};
		
		[self addSubview:aBtn];
	}
}

- (void)showInterstitialAnimated:(BOOL)animated
{
	self.parentView = [CWUtilities getTopViewController].view;
	[self updateAdLayout];
	
	if (animated) {
		self.alpha = 0.f;
		[self willAppear];
		[self.parentView addSubview:self];
		[UIView animateWithDuration:0.5f animations:^{
			self.alpha = 1.f;
		} completion:^(BOOL finished) {
			[self didAppear];
		}];
	}
	else {
		self.alpha = 1.f;
		[self willAppear];
		[self.parentView addSubview:self];
		[self didAppear];
	}
}

- (void)hideInterstitialAnimated:(BOOL)animated
{
	if (animated) {
		[self willDisappear];
		[UIView animateWithDuration:0.5 animations:^{
			self.alpha = 0.f;
		} completion:^(BOOL finished) {
			[self didDisappear];
			[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
			[self removeFromSuperview];
		}];
	}
	else {
		[self willDisappear];
		[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.alpha = 0.f;
		[self didDisappear];
		[self removeFromSuperview];
	}
}

- (void)willAppear
{
	if ([self.delegate respondsToSelector:@selector(viewWillAppear:)]) {
		[self.delegate viewWillAppear:self];
	}
}

- (void)didAppear
{
	if ([self.delegate respondsToSelector:@selector(viewDidAppear:)]) {
		[self.delegate viewDidAppear:self];
	}
}

- (void)willDisappear
{
	if ([self.delegate respondsToSelector:@selector(viewWillDisappear:)]) {
		[self.delegate viewWillDisappear:self];
	}
}

- (void)didDisappear
{
	if ([self.delegate respondsToSelector:@selector(viewDidDisappear:)]) {
		[self.delegate viewDidDisappear:self];
	}
}

- (void)closeButtonPressed
{
	[self.delegate closeButtonPressed:self];
}

- (void)updateRemainingTime:(NSTimeInterval)remainingTime
{
	UILabel *timerLabel = (UILabel *)[self viewWithTag:kAdTimerLabelTag];
	int remainingTimeInt = remainingTime;
	timerLabel.text = [NSString stringWithFormat:@"This ad will close in %i seconds.", remainingTimeInt];
}


@end
