//
//  CWAdsViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWAdsViewController.h"
#import "CWInterstitialAdsView.h"

static NSTimeInterval const kAdTimerDuration = 5.f;

@interface CWAdsViewController () <CWInterstitialAdsViewDelegate> {
	NSTimeInterval remainingTime;
}

@property (nonatomic, strong) CWInterstitialAdsView *interstitialAds;
@property (nonatomic, strong) NSArray *interstitialImages;
@property (nonatomic, strong) NSTimer *adTimer;

@end

@implementation CWAdsViewController

- (void)dealloc
{
	[_adTimer invalidate];
}

- (void)showInterstitalAdsAnimated:(BOOL)isAnimated
{
	[self.interstitialAds showInterstitialAnimated:isAnimated];
}

- (void)hideInterstitalAdsAnimated:(BOOL)isAnimated
{
	
}

- (CWInterstitialAdsView *)interstitialAds
{
	if (!_interstitialAds) {
		_interstitialAds = [[CWInterstitialAdsView alloc] init];
		_interstitialAds.delegate = self;
	}
	return _interstitialAds;
}

- (NSArray *)interstitialImages
{
	if (!_interstitialImages) {
		_interstitialImages = [NSArray arrayWithObjects:
							   @"Courseware.bundle/sponsors/sponsors-1.jpg",
							   @"Courseware.bundle/sponsors/sponsors-2.jpg",
							   nil];
	}
	return _interstitialImages;
}

- (void)updateTimer:(id)theTimer
{
	if (remainingTime <= 0.f) {
		[self.interstitialAds hideInterstitialAnimated:YES];
	}
	else {
		[self.interstitialAds updateRemainingTime:remainingTime];
		remainingTime = remainingTime - 1.f;
	}
}

- (UIImage *)adsImage:(id)theView
{
	int randomIdx = arc4random() % [self.interstitialImages count];
	return [UIImage imageNamed:[self.interstitialImages objectAtIndex:randomIdx]];
}

- (UIColor *)adsOverlayColor:(id)theView
{
	return [UIColor colorWithWhite:0 alpha:0.8];
}

- (NSString *)adTitle:(id)theView
{
	return @"SPONSORS";
}

- (BOOL)adsisCloseable:(id)theView
{
	return YES;
}

- (void)closeButtonPressed:(id)theView
{
	[self.interstitialAds hideInterstitialAnimated:YES];
}

- (void)viewWillAppear:(id)theView
{
	remainingTime = kAdTimerDuration;
	[self.adTimer invalidate];
	[self updateTimer:self];
	self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(id)theView
{
	[self.adTimer invalidate];
}

@end
