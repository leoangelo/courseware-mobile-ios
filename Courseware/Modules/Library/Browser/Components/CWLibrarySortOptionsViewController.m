//
//  CWLibrarySortOptionsViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibrarySortOptionsViewController.h"

@interface CWLibrarySortOptionsViewController ()

@end

@implementation CWLibrarySortOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *anIdentifier = @"Cell";
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anIdentifier];
	if (!aCell) {
		aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anIdentifier];
	}
	switch (indexPath.row) {
		case 0: aCell.textLabel.text = @"Sort by Name"; break;
		case 1: aCell.textLabel.text = @"Sort by Type"; break;
		case 2: aCell.textLabel.text = @"Sort by Most Recent"; break;
		default: break;
	}
    return aCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate sortOptionSelected:indexPath.row];
}

@end
