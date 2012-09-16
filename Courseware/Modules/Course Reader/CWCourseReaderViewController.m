//
//  CWCourseReaderViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseReaderViewController.h"
#import "CWNavigationBar.h"
#import "CWBottomToolbar.h"
#import "SLSlideMenuView.h"
#import "ReaderDocument.h"
#import "ReaderContentView.h"
#import "CWCourseReaderModel.h"

#pragma mark Constants

#define PAGING_VIEWS 3
#define TAP_AREA_SIZE 48.0f

@interface CWCourseReaderViewController () <ReaderContentViewDelegate> {
	
	NSInteger currentPage;
	NSMutableDictionary *contentViews;
	CWCourseReaderModel *model;
	ReaderDocument *document;
	BOOL isVisible;
	CGSize lastAppearSize;
	
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet CWBottomToolbar *toolbar;

@end

@implementation CWCourseReaderViewController

- (void)dealloc
{
	[_scrollView release];
	[_navBar release];
	[_toolbar release];
	[contentViews release];
	[document release];
	[model release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		model = [[CWCourseReaderModel alloc] init];
		document = [[CWCourseReaderModel sampleDocument] retain];
		[document updateProperties];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[contentViews release];
	contentViews = nil;
	contentViews = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.scrollView = nil;
	self.navBar = nil;
	self.toolbar = nil;
	
	[contentViews release]; contentViews = nil;
	currentPage = 0;
	lastAppearSize = CGSizeZero;
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewWillAppear:animated];
	
	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
			[self updateScrollViewContentViews]; // Update content views
		}
		
		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
}

- (void)viewDidAppear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewDidAppear:animated];
	
	if (CGSizeEqualToSize(_scrollView.contentSize, CGSizeZero)) // First time
	{
		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
	}
	
#if (READER_DISABLE_IDLE == TRUE) // Option
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewWillDisappear:animated];
	
	lastAppearSize = self.view.bounds.size; // Track view size
	
#if (READER_DISABLE_IDLE == TRUE) // Option
	
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Scroll View Support

- (void)updateScrollViewContentSize
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	NSInteger count = [document.pageCount integerValue];
	
	if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit
	
	CGFloat contentHeight = _scrollView.bounds.size.height;
	
	CGFloat contentWidth = (_scrollView.bounds.size.width * count);
	
	_scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateScrollViewContentViews
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[self updateScrollViewContentSize]; // Update the content size
	
	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
	
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
	 ^(id key, id object, BOOL *stop)
	 {
		 ReaderContentView *contentView = object; [pageSet addIndex:contentView.tag];
	 }
	 ];
	
	__block CGRect viewRect = CGRectZero; viewRect.size = _scrollView.bounds.size;
	
	__block CGPoint contentOffset = CGPointZero; NSInteger page = [document.pageNumber integerValue];
	
	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
	 ^(NSUInteger number, BOOL *stop)
	 {
		 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
		 
		 ReaderContentView *contentView = [contentViews objectForKey:key];
		 
		 contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;
		 
		 viewRect.origin.x += viewRect.size.width; // Next view frame position
	 }
	 ];
	
	if (CGPointEqualToPoint(_scrollView.contentOffset, contentOffset) == false)
	{
		_scrollView.contentOffset = contentOffset; // Update content offset
	}
}

- (void)showDocumentPage:(NSInteger)page
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (page != currentPage) // Only if different
	{
		NSInteger minValue; NSInteger maxValue;
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1;
		
		if ((page < minPage) || (page > maxPage)) return;
		
		if (maxPage <= PAGING_VIEWS) // Few pages
		{
			minValue = minPage;
			maxValue = maxPage;
		}
		else // Handle more pages
		{
			minValue = (page - 1);
			maxValue = (page + 1);
			
			if (minValue < minPage)
			{minValue++; maxValue++;}
			else
				if (maxValue > maxPage)
				{minValue--; maxValue--;}
		}
		
		NSMutableIndexSet *newPageSet = [NSMutableIndexSet new];
		
		NSMutableDictionary *unusedViews = [contentViews mutableCopy];
		
		CGRect viewRect = CGRectZero; viewRect.size = _scrollView.bounds.size;
		
		for (NSInteger number = minValue; number <= maxValue; number++)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key
			
			ReaderContentView *contentView = [contentViews objectForKey:key];
			
			if (contentView == nil) // Create a brand new document content view
			{
				NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
				
				contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
				
				[_scrollView addSubview:contentView]; [contentViews setObject:contentView forKey:key];
				
				contentView.message = self; [contentView release]; [newPageSet addIndex:number];
			}
			else // Reposition the existing content view
			{
				contentView.frame = viewRect; [contentView zoomReset];
				
				[unusedViews removeObjectForKey:key];
			}
			
			viewRect.origin.x += viewRect.size.width;
		}
		
		[unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
		 ^(id key, id object, BOOL *stop)
		 {
			 [contentViews removeObjectForKey:key];
			 
			 ReaderContentView *contentView = object;
			 
			 [contentView removeFromSuperview];
		 }
		 ];
		
		[unusedViews release], unusedViews = nil; // Release unused views
		
		CGFloat viewWidthX1 = viewRect.size.width;
		CGFloat viewWidthX2 = (viewWidthX1 * 2.0f);
		
		CGPoint contentOffset = CGPointZero;
		
		if (maxPage >= PAGING_VIEWS)
		{
			if (page == maxPage)
				contentOffset.x = viewWidthX2;
			else
				if (page != minPage)
					contentOffset.x = viewWidthX1;
		}
		else
			if (page == (PAGING_VIEWS - 1))
				contentOffset.x = viewWidthX1;
		
		if (CGPointEqualToPoint(_scrollView.contentOffset, contentOffset) == false)
		{
			_scrollView.contentOffset = contentOffset; // Update content offset
		}
		
		if ([document.pageNumber integerValue] != page) // Only if different
		{
			document.pageNumber = [NSNumber numberWithInteger:page]; // Update page number
		}
		
		NSURL *fileURL = document.fileURL; NSString *phrase = document.password; NSString *guid = document.guid;
		
		if ([newPageSet containsIndex:page] == YES) // Preview visible page first
		{
			NSNumber *key = [NSNumber numberWithInteger:page]; // # key
			
			ReaderContentView *targetView = [contentViews objectForKey:key];
			
			[targetView showPageThumb:fileURL page:page password:phrase guid:guid];
			
			[newPageSet removeIndex:page]; // Remove visible page from set
		}
		
		[newPageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock: // Show previews
		 ^(NSUInteger number, BOOL *stop)
		 {
			 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
			 
			 ReaderContentView *targetView = [contentViews objectForKey:key];
			 
			 [targetView showPageThumb:fileURL page:number password:phrase guid:guid];
		 }
		 ];
		
		[newPageSet release], newPageSet = nil; // Release new page set
		
		// [mainPagebar updatePagebar]; // Update the pagebar display
		
		// [self updateToolbarBookmarkIcon]; // Update bookmark
		
		currentPage = page; // Track current page number
	}
}

- (void)showDocument:(id)object
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[self updateScrollViewContentSize]; // Set content size
	
	[self showDocumentPage:[document.pageNumber integerValue]]; // Show
	
	document.lastOpen = [NSDate date]; // Update last opened date
	
	isVisible = YES; // iOS present modal bodge
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	__block NSInteger page = 0;
	
	CGFloat contentOffsetX = scrollView.contentOffset.x;
	
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
	 ^(id key, id object, BOOL *stop)
	 {
		 ReaderContentView *contentView = object;
		 
		 if (contentView.frame.origin.x == contentOffsetX)
		 {
			 page = contentView.tag; *stop = YES;
		 }
	 }
	 ];
	
	if (page != 0) [self showDocumentPage:page]; // Show the page
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[self showDocumentPage:_scrollView.tag]; // Show page
	
	_scrollView.tag = 0; // Clear page number tag
}

#pragma mark UIGestureRecognizer action methods

- (void)decrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (_scrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != minPage))
		{
			CGPoint contentOffset = _scrollView.contentOffset;
			
			contentOffset.x -= _scrollView.bounds.size.width; // -= 1
			
			[_scrollView setContentOffset:contentOffset animated:YES];
			
			_scrollView.tag = (page - 1); // Decrement page number
		}
	}
}

- (void)incrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (_scrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != maxPage))
		{
			CGPoint contentOffset = _scrollView.contentOffset;
			
			contentOffset.x += _scrollView.bounds.size.width; // += 1
			
			[_scrollView setContentOffset:contentOffset animated:YES];
			
			_scrollView.tag = (page + 1); // Increment page number
		}
	}
}

#pragma mark ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
//#ifdef DEBUGX
//	NSLog(@"%s", __FUNCTION__);
//#endif
//	
//	if ((mainToolbar.hidden == NO) || (mainPagebar.hidden == NO))
//	{
//		if (touches.count == 1) // Single touches only
//		{
//			UITouch *touch = [touches anyObject]; // Touch info
//			
//			CGPoint point = [touch locationInView:self.view]; // Touch location
//			
//			CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);
//			
//			if (CGRectContainsPoint(areaRect, point) == false) return;
//		}
//		
//		[mainToolbar hideToolbar]; [mainPagebar hidePagebar]; // Hide
//		
//		[lastHideTime release]; lastHideTime = [NSDate new];
//	}
}

@end
