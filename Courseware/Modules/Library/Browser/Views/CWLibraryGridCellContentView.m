//
//  CWLibraryGridCellContentView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryGridCellContentView.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

// Because GMGridView highlights the subview of the content view (and not the content view itself)
@interface CWLibraryGridCellHighlighter : UIView

@property (nonatomic) BOOL highlighted;

@end

@implementation CWLibraryGridCellHighlighter

- (void)setHighlighted:(BOOL)highlighted
{
	_highlighted = highlighted;
	[[self superview] setNeedsDisplay];
}

@end

@interface CWLibraryGridCellContentView ()

@property (nonatomic) NSInteger randomSeeded;
@property (nonatomic, strong) CWLibraryGridCellHighlighter *highlighter;

@end

@implementation CWLibraryGridCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
	
		self.randomSeeded = arc4random() % 8;
		
		_highlighter = [[CWLibraryGridCellHighlighter alloc] initWithFrame:self.bounds];
		_highlighter.backgroundColor = [UIColor clearColor];
		[self addSubview:_highlighter];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	
	// Draw the book cover
	UIImage *imageToDraw = [UIImage imageNamed:[NSString stringWithFormat:@"Courseware.bundle/book-covers/cover-%i.png", self.randomSeeded]];
	CGRect imageRect = (CGRect) {
		roundf((rect.size.width - imageToDraw.size.width) / 2.f),
		rect.size.height - imageToDraw.size.height,
		imageToDraw.size
	};
	// ..then draw the image
	[imageToDraw drawInRect:imageRect];
	
	// Configure text color, shadow, etc
	[[UIColor whiteColor] set];
	CGContextSetShadowWithColor(ctx, CGSizeMake(0, -2), 3, [UIColor colorWithWhite:0 alpha:0.7].CGColor);
	
	// Draw the title
	UIFont *titleFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	CGSize titleSize = [self.title sizeWithFont:titleFont];
	CGRect titleRect = (CGRect) {
		roundf((rect.size.width - titleSize.width) / 2.f),
		rect.size.height - titleSize.height,
		titleSize
	};
	[self.title drawInRect:titleRect withFont:titleFont];
	
	// Cast a glow when highlighted.
	if (self.highlighter.highlighted) {
		[[UIColor colorWithWhite:1 alpha:0.2] set];
		CGContextSetShadowWithColor(ctx, CGSizeMake(0, -2), 3, [UIColor colorWithWhite:1 alpha:0.7].CGColor);
		CGRect glowRect = CGRectInset(imageRect, -3, -3);
		CGContextFillRect(ctx, glowRect);
	}
	
	UIGraphicsPopContext();
}

@end
