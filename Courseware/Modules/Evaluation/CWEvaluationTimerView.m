//
//  CWEvaluationTimerView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationTimerView.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@implementation CWEvaluationTimerView

- (void)updateRemainingTimeCounter:(NSTimeInterval)time total:(NSTimeInterval)total
{
	remainingTime = time;
	totalTime = total;
	[self setNeedsDisplay];
}

+ (UIColor *)colorToShowWithPct:(CGFloat)thePct
{
	// bound the range of colors from red to green
	CGFloat fromGreen = ((thePct * 30.f) / 150.f) + 0.70f;
	fromGreen = 1.f - fromGreen; // reverse
	return [UIColor colorWithHue:fromGreen saturation:.9 brightness:.72 alpha:1.];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	
	NSTimeInterval boundTime = totalTime - remainingTime;
	boundTime = boundTime < 0.f ? 0.f : boundTime;
	boundTime = boundTime > totalTime ? totalTime : boundTime;
	
	if (totalTime <= 0) return;
	
	CGFloat progressPct = boundTime / totalTime;
	CGRect progressRect = (CGRect) {
		0,
		0,
		rect.size.width * progressPct,
		20
	};

	CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:0.8].CGColor);
	CGContextFillRect(ctx, (CGRect) {
		CGPointZero,
		rect.size.width,
		20
	});
	CGContextSetFillColorWithColor(ctx, [[self class] colorToShowWithPct:progressPct].CGColor);
	CGContextFillRect(ctx, progressRect);
	
	UIFont *printFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	int remainingInt = ceil(remainingTime);
	NSString *toPrint = [NSString stringWithFormat:@"Time left: %is", remainingInt];
	[[[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES] set];
	CGSize printSize = [toPrint sizeWithFont:printFont];
	CGRect printRect = (CGRect) {
		rect.size.width - printSize.width,
		CGRectGetMaxY(progressRect) + 4,
		printSize
	};
	[toPrint drawInRect:printRect withFont:printFont];
	
	UIGraphicsPopContext();
}

@end
