//
//  CWEvaluationProgressView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationProgressView.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@implementation CWEvaluationProgressView

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	
//	CGFloat progressPct = [self.dataSource currentItemIndex] * 1.f / [self.dataSource totalNumberOfItems] * 1.f;
//	CGRect progressRect = (CGRect) {
//		0,
//		0,
//		rect.size.width * progressPct,
//		20
//	};

//	CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:0.8].CGColor);
//	CGContextFillRect(ctx, (CGRect) {
//		CGPointZero,
//		rect.size.width,
//		20
//	});
//	CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.25 green:.50 blue:0 alpha:1.f].CGColor);
//	CGContextFillRect(ctx, progressRect);
	
	UIFont *printFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	NSString *toPrint = [NSString stringWithFormat:@"Question %i / %i", [self.dataSource currentItemIndex], [self.dataSource totalNumberOfItems]];
	[[[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES] set];
	CGSize printSize = [toPrint sizeWithFont:printFont];
	CGRect printRect = (CGRect) {
//		rect.size.width - printSize.width,
//		rect.size.height - printSize.height,
		0, 0,
		printSize
	};
	[toPrint drawInRect:printRect withFont:printFont];
	
	UIGraphicsPopContext();
}

@end
