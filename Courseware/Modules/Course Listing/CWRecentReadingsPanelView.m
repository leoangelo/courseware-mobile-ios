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
#import "CWConstants.h"

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

- (void)updateContent
{
	[self.controller rebuildLessonsIndex];
	[self.tableView reloadData];
}

- (void)updateFontAndColor
{
	self.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.tableView reloadData];
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
		cell.indentationWidth = 0.f;
		cell.indentationLevel = 0;
	}
	CWCourseItem *lessonAtIndex = [[self.controller getRecentReads] objectAtIndex:indexPath.row];
	CWCourseItem *parentChapter = lessonAtIndex.parent;
	
	cell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES];
	cell.detailTextLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	
	cell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
	cell.detailTextLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:15]];
	
	cell.textLabel.text = [lessonAtIndex.data objectForKey:kCourseItemTitle];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"From the chapter %@", [parentChapter.data objectForKey:kCourseItemTitle]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CWCourseItem *lessonAtIndex = [[self.controller getRecentReads] objectAtIndex:indexPath.row];
	[self.delegate recentReadingSelectedCourseItem:lessonAtIndex];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	static CGFloat const kHeaderMargin = 10.f;
	UILabel *lblSectionTitle = [[UILabel alloc] init];
	lblSectionTitle.text = @"Last Readings";
	lblSectionTitle.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontBold size:26]];
	lblSectionTitle.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	lblSectionTitle.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[lblSectionTitle sizeToFit];
	lblSectionTitle.frame = (CGRect) { kHeaderMargin, 0, tableView.frame.size.width - kHeaderMargin * 2.f, lblSectionTitle.frame.size.height };
	
	UIView *wrapperView = [[UIView alloc] initWithFrame:lblSectionTitle.frame];
	wrapperView.backgroundColor = [UIColor clearColor];
	[wrapperView addSubview:lblSectionTitle];
	
	return wrapperView;
}

@end
