//
//  CWLibrarySortOptionsViewController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWLibrarySortOptionsViewControllerDelegate <NSObject>

- (void)sortOptionSelected:(NSInteger)theOption;

@end

@interface CWLibrarySortOptionsViewController : UITableViewController

@property (nonatomic, weak) id<CWLibrarySortOptionsViewControllerDelegate> delegate;

@end
