//
//  CWLibrarySearchFilterViewController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWLibrarySearchFilterViewControllerDelegate;

@interface CWLibrarySearchFilterViewController : UITableViewController

@property (nonatomic, weak) id<CWLibrarySearchFilterViewControllerDelegate> delegate;

@end

@protocol CWLibrarySearchFilterViewControllerDelegate <NSObject>

- (void)searchFilterChanged:(NSString *)filter;

@end
