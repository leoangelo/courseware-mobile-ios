//
//  CWMessageTableViewCell.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/28/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CWMessageTableViewCell.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

NSString * const kMessageTableViewCellIdentifierLight = @"MessageTableViewCellIdentifierLight";
NSString * const kMessageTableViewCellIdentifierDark = @"MessageTableViewCellIdentifierDark";
static CGFloat const kSideMargins = 8.f;

@interface CWMessageTableViewCellContentView : UIView
@end

@implementation CWMessageTableViewCellContentView

- (void)drawRect:(CGRect)rect
{
	[(CWMessageTableViewCell *)[self superview] drawContentView:rect];
}

- (void)setNeedsLayout
{
	[(CWMessageTableViewCell *)[self superview] layoutControls];
}

@end

@interface CWMessageTableViewCell ()

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) CWMessageTableViewCellContentView *myContentView;

- (void)checkButtonPressed:(UIButton *)target;

@end

@implementation CWMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.myContentView = [[CWMessageTableViewCellContentView alloc] init];
		self.myContentView.contentMode = UIViewContentModeTopLeft;
		self.myContentView.autoresizingMask = UIViewAutoresizingNone;
		self.myContentView.backgroundColor = [UIColor clearColor];
		[self addSubview:self.myContentView];
		
		UIView *normalBg = [[UIView alloc] init];
		UIView *selectedBg = [[UIView alloc] init];
		
		normalBg.layer.masksToBounds = YES;
		normalBg.layer.cornerRadius = 6.f;
		
		selectedBg.layer.masksToBounds = YES;
		selectedBg.layer.cornerRadius = 6.f;
		
		if ([reuseIdentifier isEqualToString:kMessageTableViewCellIdentifierDark]) {
			normalBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
			selectedBg.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
		}
		else {
			normalBg.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.6];
			selectedBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		}
		self.backgroundView = normalBg;
		self.selectedBackgroundView = selectedBg;
    }
    return self;
}

- (UIButton *)checkButton
{
	if (!_checkButton) {
		_checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_checkButton setAdjustsImageWhenHighlighted:NO];
		[_checkButton addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_checkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[self.myContentView addSubview:_checkButton];
	}
	return _checkButton;
}

- (void)checkButtonPressed:(UIButton *)target
{
	[self.delegate checkButtonPressed:self];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self.myContentView setFrame:self.bounds];
	[self.myContentView setNeedsDisplay];
	[self.myContentView setNeedsLayout];
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[self.myContentView setNeedsDisplay];
}

- (void)setNeedsLayout
{
	[super setNeedsLayout];
	[self.myContentView setNeedsLayout];
}

- (void)drawContentView:(CGRect)r
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	
	// The font to use in the cell
	UIFont *aFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:(self.unread ? kGlobalAppFontBold : kGlobalAppFontNormal) size:15]];
	// Color for text
	[[[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO] set];
	
	CGFloat xOffset = kSideMargins;
	
	CGFloat selectorWidth = 30.f;
	CGFloat columnWidth = roundf((r.size.width - (kSideMargins * 4.f) - selectorWidth) / 3.f); // 4 margins, 3 columns
	
	// Draw the selector button
	xOffset += selectorWidth;
	
	// Draw the sender
	CGSize senderSize = [self.sender sizeWithFont:aFont];
	CGPoint senderPoint = (CGPoint) {
		xOffset,
		roundf((r.size.height - senderSize.height) / 2.f)
	};
	[self.sender drawAtPoint:senderPoint forWidth:columnWidth withFont:aFont lineBreakMode:UILineBreakModeTailTruncation];
	xOffset += columnWidth + kSideMargins;
	
	// Draw the title
	CGSize titleSize = [self.title sizeWithFont:aFont];
	CGPoint titlePoint = (CGPoint) {
		xOffset,
		roundf((r.size.height - titleSize.height) / 2.f)
	};
	[self.title drawAtPoint:titlePoint forWidth:columnWidth withFont:aFont lineBreakMode:UILineBreakModeTailTruncation];
	xOffset += columnWidth + kSideMargins;
	
	// Draw the date
	CGSize dateSize = [self.date sizeWithFont:aFont];
	CGPoint datePoint = (CGPoint) {
		xOffset,
		roundf((r.size.height - dateSize.height) / 2.f)
	};
	[self.date drawAtPoint:datePoint forWidth:columnWidth withFont:aFont lineBreakMode:UILineBreakModeTailTruncation];
	
	UIGraphicsPopContext();
}

- (void)layoutControls
{
	UIImage *checkImage = nil;
	if (self.checked) {
		checkImage = [UIImage imageNamed:@"Courseware.bundle/controls/message-control-selected.png"];
	}
	else {
		checkImage = [UIImage imageNamed:@"Courseware.bundle/controls/message-control.png"];
	}
	[self.checkButton setImage:checkImage forState:UIControlStateNormal];
	CGSize buttonSize = CGSizeMake(32, 32);
	[self.checkButton setFrame:(CGRect) {
		kSideMargins,
		roundf((self.checkButton.superview.frame.size.height - buttonSize.height) / 2.f),
		buttonSize
	}];
}

@end
