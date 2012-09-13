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

#define HEADER_MARGINS 10
#define HEADER_HEIGHT 300

@interface CWBrowserPaneView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CWBrowserPaneController *controller;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UIImageView *imgLogoView;

- (void)loadNib;

@end

@implementation CWBrowserPaneView

- (void)dealloc
{
	_delegate = nil;
	[_imgLogoView release];
	[_tableView release];
	[_contentView release];
	[_controller release];
	[super dealloc];
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

- (void)loadNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWBrowserPaneView" owner:self options:nil];
	[self addSubview:self.contentView];
	
	self.controller = [[[CWBrowserPaneController alloc] init] autorelease];
	
	self.tableView.backgroundView = nil;
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.controller.getItemsToDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *itemTitle = [(CWCourseItem *)[self.controller.getItemsToDisplay objectAtIndex:indexPath.row] title];
	return [itemTitle sizeWithFont:[UIFont fontWithName:@"FuturaLT-Heavy" size:17] constrainedToSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
	}
	NSString *itemTitle = [(CWCourseItem *)[self.controller.getItemsToDisplay objectAtIndex:indexPath.row] title];
	cell.textLabel.text = itemTitle;
	cell.textLabel.font = [UIFont fontWithName:@"FuturaLT-Heavy" size:17];
	cell.textLabel.numberOfLines = 0;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *wrapperView = [[UIView alloc] initWithFrame:(CGRect) {
		CGPointZero,
		self.tableView.frame.size.width,
		HEADER_HEIGHT
	}];
	
	[wrapperView addSubview:self.imgLogoView];
	
	self.imgLogoView.frame = (CGRect) {
		roundf((wrapperView.frame.size.width - self.imgLogoView.frame.size.width) / 2.f),
		roundf((wrapperView.frame.size.height - self.imgLogoView.frame.size.height) / 2.f),
		self.imgLogoView.frame.size
	};
	
	return [wrapperView autorelease];
}

- (UIImageView *)imgLogoView
{
	UIImage *logoImg = [UIImage imageNamed:@"Courseware.bundle/gold-institute-logo.png"];
	if (!_imgLogoView) {
		_imgLogoView = [[UIImageView alloc] initWithImage:logoImg];
	}
	CGFloat maxWidth = self.tableView.frame.size.width - HEADER_MARGINS * 2;
	if (logoImg.size.width > maxWidth) {
		CGFloat imgProportion = logoImg.size.height / logoImg.size.width;
		CGFloat imgHeight = maxWidth * imgProportion;
		_imgLogoView.frame = (CGRect) {
			CGPointZero,
			maxWidth,
			imgHeight
		};
	}
	return _imgLogoView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CWCourseItem *selectedItem = [self.controller.getItemsToDisplay objectAtIndex:indexPath.row];
	
	[self.delegate browser:self selectedItem:selectedItem];
}

@end
