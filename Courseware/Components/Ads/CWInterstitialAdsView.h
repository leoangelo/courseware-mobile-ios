//
//  CWInterstitialAdsView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWInterstitialAdsViewDelegate <NSObject>

- (UIImage *)adsImage:(id)theView;
- (UIColor *)adsOverlayColor:(id)theView;
- (NSString *)adTitle:(id)theView;

- (BOOL)adsisCloseable:(id)theView;
- (void)closeButtonPressed:(id)theView;

@optional
- (void)viewWillAppear:(id)theView;
- (void)viewDidAppear:(id)theView;
- (void)viewWillDisappear:(id)theView;
- (void)viewDidDisappear:(id)theView;

@end

@interface CWInterstitialAdsView : UIView

@property (nonatomic, assign) id<CWInterstitialAdsViewDelegate> delegate;

- (void)showInterstitialAnimated:(BOOL)animated;
- (void)hideInterstitialAnimated:(BOOL)animated;
- (void)updateRemainingTime:(NSTimeInterval)remainingTime;

@end