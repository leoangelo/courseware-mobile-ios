//
//  CWRecentReadingsPanelView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWRecentReadingsPanelView.h"
#import "CWRecentReadingsPanelController.h"
#import "CWCourseItem.h"

@interface CWRecentReadingsPanelView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CWRecentReadingsPanelController *controller;

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)loadNib;

@end

@implementation CWRecentReadingsPanelView

- (void)dealloc
{
	_tableView.dataSource = nil;
	_tableView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.controller = [[CWRecentReadingsPanelController alloc] init];
		[self loadNib];
    }
    return self;
}

- (void)awakeFromNib
{
	self.controller = [[CWRecentReadingsPanelController alloc] init];
	[self loadNib];
}

- (void)loadNib
{
	[[NSBundle mainBundle] loadNibNamed:@"CWRecentReadingsPanelView" owner:self options:nil];
	[self addSubview:self.contentView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.controller.getRecentReads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"RecentReadingsCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}
	CWCourseItem *lessonAtIndex = [[self.controller getRecentReads] objectAtIndex:indexPath.row];
	CWCourseItem *parentChapter = lessonAtIndex.parent;
	cell.textLabel.text = [lessonAtIndex.data objectForKey:kCourseItemTitle];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"From the chapter %@", [parentChapter.data objectForKey:kCourseItemTitle]];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *lblSectionTitle = [[UILabel alloc] init];
	lblSectionTitle.text = @"Last Readings";
	lblSectionTitle.font = [UIFont fontWithName:@"FuturaLT-Heavy" size:26];
	lblSectionTitle.textColor = [UIColor blackColor];
	lblSectionTitle.backgroundColor = [UIColor clearColor];
	[lblSectionTitle sizeToFit];
	lblSectionTitle.frame = (CGRect) { 0, 0, lblSectionTitle.frame.size };
	
	UIView *wrapperView = [[UIView alloc] initWithFrame:lblSectionTitle.frame];
	wrapperView.backgroundColor = [UIColor whiteColor];
	[wrapperView addSubview:lblSectionTitle];
	
	return wrapperView;
}

@end
