//
//  SLSlideMenuView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLSlideMenuView.h"
#import "SLSlideMenuController.h"

#define HEADER_HEIGHT 24
#define FOOTER_HEIGHT 42
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180

@interface SLSlideMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) SLSlideMenuController *controlller;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIImageView *imgBackground;
@property (nonatomic, retain) IBOutlet UITableView *listView;
@property (nonatomic, retain) IBOutlet UIButton *btnSlideAction;

@property (nonatomic, getter = isDisplayed) BOOL displayed;

- (void)layoutNib;
- (IBAction)slideActionPressed:(id)sender;

@end

@implementation SLSlideMenuView

- (void)dealloc
{
	[_listView release];
	[_imgBackground release];
	[_contentView release];
	[_controlller release];
	[super dealloc];
}

+ (id)slideMenuView
{
	SLSlideMenuView *aView = [[SLSlideMenuView alloc] initWithFrame:CGRectMake(0, 0, 220, 370)];
	return [aView autorelease];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self layoutNib];
    }
    return self;
}

- (void)awakeFromNib
{
	[self layoutNib];
}

- (void)layoutNib
{
	self.controlller = [[[SLSlideMenuController alloc] init] autorelease];
	
	self.backgroundColor = [UIColor clearColor];
	
	[[NSBundle mainBundle] loadNibNamed:@"SLSlideMenuView" owner:self options:nil];
	[self addSubview:self.contentView];
	
	self.imgBackground.image = [[UIImage imageNamed:@"Courseware.bundle/slide-menu-bg.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
	[self.btnSlideAction setImage:[UIImage imageNamed:@"Courseware.bundle/slide-menu-arrow-down.png"] forState:UIControlStateNormal];
}

- (void)attachToNavBar:(UINavigationBar *)navBar
{
	if (self.superview) {
		[self removeFromSuperview];
	}
	if (navBar.superview) {
		[navBar.superview insertSubview:self belowSubview:navBar];
	}
	self.frame = (CGRect) {
		navBar.frame.origin.x + 8,
		navBar.frame.origin.y + navBar.frame.size.height + FOOTER_HEIGHT - self.frame.size.height,
		self.frame.size
	};
	[self setDisplayed:NO];
}

- (void)setSticky:(BOOL)sticky
{
	_sticky = sticky;
	if (_sticky) {
		[self setDisplayed:YES animated:NO];
	}
	self.btnSlideAction.hidden = _sticky;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	NSLog(@"Table view height: %f", self.listView.contentSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.controlller.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		cell.textLabel.font = [UIFont fontWithName:@"FuturaLT-Heavy" size:18];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	SLSlideMenuItem *rowItem = [self.controlller.menuItems objectAtIndex:indexPath.row];
	if (rowItem.itemText) {
		cell.textLabel.text = rowItem.itemText;
	}
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.controlller didPressMenuItemAtIndex:indexPath.row];
}

- (void)slideActionPressed:(id)sender
{
	[self.listView deselectRowAtIndexPath:self.listView.indexPathForSelectedRow animated:YES];
	[self setDisplayed:!_displayed animated:YES];
}

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)isAnimated
{
	if (isAnimated) {
		[UIView animateWithDuration:0.3 animations:^{
			if (displayed) {
				[self showMenu];
			}
			else {
				[self hideMenu];
			}
		} completion:^(BOOL finished) {
			_displayed = displayed;
		}];
	}
	else {
		if (displayed) {
			[self showMenu];
		}
		else {
			[self hideMenu];
		}
		_displayed = displayed;
	}
}

- (void)showMenu
{
	self.frame = (CGRect) {
		self.frame.origin.x,
		44 - HEADER_HEIGHT,
		self.frame.size
	};
	self.btnSlideAction.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
}

- (void)hideMenu
{
	self.frame = (CGRect) {
		self.frame.origin.x,
		44 + FOOTER_HEIGHT - self.frame.size.height,
		self.frame.size
	};
	self.btnSlideAction.transform = CGAffineTransformIdentity;
}

@end
