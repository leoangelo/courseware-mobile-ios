//
//  CWLibrarySearchFilterViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibrarySearchFilterViewController.h"
#import "CWThemeHelper.h"

@interface CWLibrarySearchFilterViewController () <CWThemeDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CWLibrarySearchFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.scrollEnabled = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateFontAndColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISearchBar *)searchBar
{
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
		_searchBar.barStyle = UIBarStyleBlack;
		_searchBar.delegate = self;
	}
	return _searchBar;
}

- (void)updateFontAndColor
{
	self.searchBar.barStyle = [[CWThemeHelper sharedHelper] colorTheme] == CWUserPrefsColorThemeDark ? UIBarStyleBlack : UIBarStyleDefault;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.delegate searchFilterChanged:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self.delegate searchFilterChanged:searchText];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.tableView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		[cell.contentView addSubview:self.searchBar];
	}
	
	self.searchBar.frame = (CGRect) {
		CGPointZero,
		tableView.frame.size.width,
		tableView.frame.size.height
	};
    
    return cell;
}

@end
