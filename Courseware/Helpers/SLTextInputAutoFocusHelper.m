//
//  SLTextInputAutoFocusHelper.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLTextInputAutoFocusHelper.h"

@interface SLTextInputAutoFocusHelper ()

@property (nonatomic, weak) UIScrollView *activeScrollView;

- (void)handleKeyboardShow:(NSNotification *)notification;
- (void)handleKeyboardHide:(NSNotification *)notification;

- (void)autoFocusTextInputWithKeyboardFrame:(CGRect)keyboardFrame;

- (UIWindow *)getKeyWindow;
- (UIView *)getFirstResponder;
- (UIView *)getFirstResponderFromView:(UIView *)theView;
- (UIScrollView *)getParentScrollView:(UIView *)theView;
- (UIView *)getNavigationView;

@end

@implementation SLTextInputAutoFocusHelper

+ (SLTextInputAutoFocusHelper *)sharedHelper
{
	static SLTextInputAutoFocusHelper *helper = nil;
	@synchronized([SLTextInputAutoFocusHelper class]) {
		if (!helper) {
			helper = [[SLTextInputAutoFocusHelper alloc] init];
		}
	}
	return helper;
}

- (void)beginAutoFocus
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
	
	_activeScrollView = nil;
}

- (void)stopAutoFocus
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	_activeScrollView = nil;
}

- (void)handleKeyboardShow:(NSNotification *)notification
{
	CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self autoFocusTextInputWithKeyboardFrame:keyboardFrame];
}

- (void)handleKeyboardHide:(NSNotification *)notification
{
	if (_activeScrollView) {
		[_activeScrollView setContentOffset:CGPointZero animated:YES];
	}
}

- (void)autoFocusTextInputWithKeyboardFrame:(CGRect)keyboardFrame
{
	UIView *firstResponder = [self getFirstResponder];
	if (firstResponder) {
		// NSLog(@"First responder: %@", firstResponder);
		UIScrollView *parentScrollView = [self getParentScrollView:firstResponder];
		if (parentScrollView) {
			// NSLog(@"Parent scroll view: %@", parentScrollView);
			
			CGRect firstResponderRect = [firstResponder convertRect:[firstResponder bounds] toView:[self getNavigationView]];
			// NSLog(@"FR rect: %@", NSStringFromCGRect(firstResponderRect));
			
			CGRect convKeyboardRect = [[self getNavigationView] convertRect:keyboardFrame fromView:nil];
			// NSLog(@"KB rect: %@", NSStringFromCGRect(convKeyboardRect));
			
			// the max y of the first responder should always be above the keyboard's rect
			CGFloat diffY = CGRectGetMaxY(firstResponderRect) - convKeyboardRect.origin.y;
				
			if (diffY > 0) {
				_activeScrollView = parentScrollView;
				[parentScrollView setContentOffset:CGPointMake(0, diffY) animated:YES];
			}
			
		}
		else {
			NSLog(@"Problem: No scroll view found");
		}
	}
	else {
		NSLog(@"Problem: No first responder found");
	}
}

- (UIView *)getKeyWindow
{
	return [[UIApplication sharedApplication] keyWindow];
}

- (UIView *)getFirstResponder
{
	
	return [self getFirstResponderFromView:[self getKeyWindow]];
}

- (UIView *)getFirstResponderFromView:(UIView *)theView
{	
	if (theView.isFirstResponder) {
		return theView;
	}	
	else {
		for (UIView *subView in [theView subviews]) {
			UIView *firstResponder = [self getFirstResponderFromView:subView];
			if (firstResponder != nil) {
				return firstResponder;
			}
		}
	}
	return nil;
}

- (UIScrollView *)getParentScrollView:(UIView *)theView
{
	for (UIView *currentView = theView.superview; currentView != nil; currentView = currentView.superview) {
		if ([currentView isKindOfClass:[UIScrollView class]]) {
			return (UIScrollView *)currentView;
		}
	}
	return nil;
}

- (UIView *)getNavigationView
{
	UIViewController *rootViewController = [[self getKeyWindow] rootViewController];
	if ([rootViewController isKindOfClass:[UINavigationController class]]) {
		return [[(UINavigationController *)rootViewController topViewController] view];
	}
	return nil;
}

@end
