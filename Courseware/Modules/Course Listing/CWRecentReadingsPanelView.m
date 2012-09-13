//
//  CWRecentReadingsPanelView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWRecentReadingsPanelView.h"
#import "CWRecentReadingsPanelController.h"
#import "CWLesson.h"
#import "CWChapter.h"

@interface CWRecentReadingsPanelView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CWRecentReadingsPanelController *controller;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)loadNib;

@end

@implementation CWRecentReadingsPanelView

- (void)dealloc
{
	_tableView.dataSource = nil;
	_tableView.delegate = nil;
	[_tableView release];
	[_contentView release];
	[_controller release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.controller = [[[CWRecentReadingsPanelController alloc] init] autorelease];
		[self loadNib];
    }
    return self;
}

- (void)awakeFromNib
{
	self.controller = [[[CWRecentReadingsPanelController alloc] init] autorelease];
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
	}
	CWLesson *lessonAtIndex = [[self.controller getRecentReads] objectAtIndex:indexPath.row];
	CWChapter *parentChapter = (CWChapter *)lessonAtIndex.parent;
	cell.textLabel.text = lessonAtIndex.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"From the chapter %@", parentChapter.title];
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
	[lblSectionTitle release];
	
	return [wrapperView autorelease];
}

@end
