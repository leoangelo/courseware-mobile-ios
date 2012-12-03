//
//  CWBrowserPaneView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBrowserPaneView.h"
#import "CWBrowserPaneController.h"
#import "CWCourseItem.h"
#import "CWConstants.h"

#define HEADER_MARGINS 10
#define HEADER_HEIGHT 300

@interface CWBrowserPaneView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CWBrowserPaneController *controller;

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *shadowView;

@property (nonatomic, weak) IBOutlet UIImageView *imgLogoView;

- (void)loadNib;

@end

@implementation CWBrowserPaneView

- (void)dealloc
{
	_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self loadNib];
    }
    return self;
}

- (void)awakeFromNib
{
	[self loadNib];
}

+ (UIColor *)menuBackground
{
	return [UIColor colorWithPatternImage:[UIImage imageNamed:@"Courseware.bundle/backgrounds/bg-tile-gray.jpg"]];
}

- (void)loadNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWBrowserPaneView" owner:self options:nil];
	[self addSubview:self.contentView];
	
	self.contentView.frame = self.bounds;
	
	self.controller = [[CWBrowserPaneController alloc] init];
	
	self.tableView.backgroundView = nil;

	self.backgroundColor = [[self class] menuBackground];
	self.shadowView.image = [[UIImage imageNamed:@"Courseware.bundle/backgrounds/shadow-bounds.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	self.imgLogoView.image = [UIImage imageNamed:@"Courseware.bundle/logos/large-logo.png"];
	
	// resize the logo and table view to properly fit the screen
	self.imgLogoView.frame = (CGRect) {
		HEADER_MARGINS, 0, (self.frame.size.width - HEADER_MARGINS * 2),
		roundf(self.frame.size.height * 0.33)
	};
	self.tableView.frame = (CGRect) {
		0, CGRectGetMaxY(self.imgLogoView.frame),
		self.frame.size.width,
		round(self.frame.size.height * 0.66)
	};
}

- (void)updateFontAndColor
{
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.controller.getItemsToDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *itemTitle = [[(CWCourseItem *)[self.controller.getItemsToDisplay objectAtIndex:indexPath.row] data] objectForKey:kCourseItemTitle];
	CGFloat textHeight = [itemTitle sizeWithFont:[[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:18]] constrainedToSize:CGSizeMake(tableView.frame.size.width - 16, CGFLOAT_MAX)].height;
	textHeight += 16;
	
	NSLog(@"text height: %f", textHeight);
	
	return MAX(textHeight, 50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
		cell.textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
		cell.textLabel.shadowOffset = CGSizeMake(1, 1);
		cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Courseware.bundle/backgrounds/browser-pane-cell-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
		cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Courseware.bundle/backgrounds/browser-pane-cell-bg-sel.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
	}
	NSString *itemTitle = [[(CWCourseItem *)[self.controller.getItemsToDisplay objectAtIndex:indexPath.row] data] objectForKey:kCourseItemTitle];
	cell.textLabel.text = itemTitle;
	cell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:18]];
	cell.textLabel.numberOfLines = 0;
	return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return HEADER_HEIGHT;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	UIView *wrapperView = [[UIView alloc] initWithFrame:(CGRect) {
//		CGPointZero,
//		self.tableView.frame.size.width,
//		HEADER_HEIGHT
//	}];
//	wrapperView.backgroundColor = [[self class] menuBackground];
//	
//	[wrapperView addSubview:self.imgLogoView];
//	
//	self.imgLogoView.frame = (CGRect) {
//		roundf((wrapperView.frame.size.width - self.imgLogoView.frame.size.width) / 2.f),
//		roundf((wrapperView.frame.size.height - self.imgLogoView.frame.size.height) / 2.f),
//		self.imgLogoView.frame.size
//	};
//	
//	return wrapperView;
//}

//- (UIImageView *)imgLogoView
//{
//	UIImage *logoImg = [UIImage imageNamed:@"Courseware.bundle/logos/large-logo.png"];
//	if (!_imgLogoView) {
//		_imgLogoView = [[UIImageView alloc] initWithImage:logoImg];
//	}
//	CGFloat maxWidth = self.tableView.frame.size.width - HEADER_MARGINS * 2;
//	if (logoImg.size.width > maxWidth) {
//		CGFloat imgProportion = logoImg.size.height / logoImg.size.width;
//		CGFloat imgHeight = maxWidth * imgProportion;
//		_imgLogoView.frame = (CGRect) {
//			CGPointZero,
//			maxWidth,
//			imgHeight
//		};
//	}
//	return _imgLogoView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CWCourseItem *selectedItem = [self.controller.getItemsToDisplay objectAtIndex:indexPath.row];
	
	[self.delegate browser:self selectedItem:selectedItem];
}

- (void)setActiveItem:(CWCourseItem *)activeItem
{
	self.controller.activeCourseItem = activeItem;
	[self.tableView reloadData];
}

@end
