//
//  CWCourseDocumentView.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/19/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseDocumentView.h"
#import "ReaderDocument.h"
#import "ReaderContentView.h"

@interface CWCourseDocumentView () <UIGestureRecognizerDelegate, ReaderContentViewDelegate, UIScrollViewDelegate> {

	NSInteger currentPage;
}

@property (nonatomic, retain) NSMutableDictionary *contentViews;

- (void)initializeGestures;

@end

#define PAGING_VIEWS 3
#define TAP_AREA_SIZE 48.0f

@implementation CWCourseDocumentView

- (void)dealloc
{
	_dataSource = nil;
	_documentDelegate = nil;
	[_contentViews release];
	[super dealloc];
}

- (void)awakeFromNib
{
	self.contentViews = [NSMutableDictionary dictionary];
	self.delegate = self;
	[self initializeGestures];
}

- (void)initializeGestures
{
	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	
	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
	
	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
	
	[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
	
	[self addGestureRecognizer:singleTapOne]; [singleTapOne release];
	[self addGestureRecognizer:doubleTapOne]; [doubleTapOne release];
	[self addGestureRecognizer:doubleTapTwo]; [doubleTapTwo release];
}

#pragma mark - Scroll View Support

- (void)updateScrollViewContentSize
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	NSInteger count = [[self.dataSource courseDocument].pageCount integerValue];
	
	if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit
	
	CGFloat contentHeight = self.bounds.size.height;
	
	CGFloat contentWidth = (self.bounds.size.width * count);
	
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateScrollViewContentViews
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	[self updateScrollViewContentSize]; // Update the content size
	
	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
	
	[_contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
	 ^(id key, id object, BOOL *stop)
	 {
		 ReaderContentView *contentView = object; [pageSet addIndex:contentView.tag];
	 }
	 ];
	
	__block CGRect viewRect = CGRectZero; viewRect.size = self.bounds.size;
	
	__block CGPoint contentOffset = CGPointZero; NSInteger page = [[self.dataSource courseDocument].pageNumber integerValue];
	
	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
	 ^(NSUInteger number, BOOL *stop)
	 {
		 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
		 
		 ReaderContentView *contentView = [_contentViews objectForKey:key];
		 
		 contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;
		 
		 viewRect.origin.x += viewRect.size.width; // Next view frame position
	 }
	 ];
	
	if (CGPointEqualToPoint(self.contentOffset, contentOffset) == false)
	{
		self.contentOffset = contentOffset; // Update content offset
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
		NSInteger maxPage = [[self.dataSource courseDocument].pageCount integerValue];
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
		
		NSMutableDictionary *unusedViews = [_contentViews mutableCopy];
		
		CGRect viewRect = CGRectZero; viewRect.size = self.bounds.size;
		
		for (NSInteger number = minValue; number <= maxValue; number++)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key
			
			ReaderContentView *contentView = [_contentViews objectForKey:key];
			
			if (contentView == nil) // Create a brand new document content view
			{
				NSURL *fileURL = [self.dataSource courseDocument].fileURL; NSString *phrase = [self.dataSource courseDocument].password; // Document properties
				
				contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
				
				[self addSubview:contentView]; [_contentViews setObject:contentView forKey:key];
				
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
			 [_contentViews removeObjectForKey:key];
			 
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
		
		if (CGPointEqualToPoint(self.contentOffset, contentOffset) == false)
		{
			self.contentOffset = contentOffset; // Update content offset
		}
		
		if ([[self.dataSource courseDocument].pageNumber integerValue] != page) // Only if different
		{
			[self.dataSource courseDocument].pageNumber = [NSNumber numberWithInteger:page]; // Update page number
		}
		
		NSURL *fileURL = [self.dataSource courseDocument].fileURL; NSString *phrase = [self.dataSource courseDocument].password; NSString *guid = [self.dataSource courseDocument].guid;
		
		if ([newPageSet containsIndex:page] == YES) // Preview visible page first
		{
			NSNumber *key = [NSNumber numberWithInteger:page]; // # key
			
			ReaderContentView *targetView = [_contentViews objectForKey:key];
			
			[targetView showPageThumb:fileURL page:page password:phrase guid:guid];
			
			[newPageSet removeIndex:page]; // Remove visible page from set
		}
		
		[newPageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock: // Show previews
		 ^(NSUInteger number, BOOL *stop)
		 {
			 NSNumber *key = [NSNumber numberWithInteger:number]; // # key
			 
			 ReaderContentView *targetView = [_contentViews objectForKey:key];
			 
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
	
	[self showDocumentPage:[[self.dataSource courseDocument].pageNumber integerValue]]; // Show
	
	[self.dataSource courseDocument].lastOpen = [NSDate date]; // Update last opened date
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	__block NSInteger page = 0;
	
	CGFloat contentOffsetX = scrollView.contentOffset.x;
	
	[_contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
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
	
	[self showDocumentPage:self.tag]; // Show page
	
	self.tag = 0; // Clear page number tag
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;
	
	return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
		
		CGPoint point = [recognizer locationInView:recognizer.view];
		
		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area
		
		if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
		{
			NSInteger page = [[self.dataSource courseDocument].pageNumber integerValue]; // Current page #
			
			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
			
			ReaderContentView *targetView = [_contentViews objectForKey:key];
			
			id target = [targetView singleTap:recognizer]; // Process tap
			
			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object
					
					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string
						
						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [NSString stringWithFormat:@"http://%@", www];
							
							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}
					
					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
#ifdef DEBUG
						NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
#endif
					}
				}
				else // Not a URL, so check for other possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger value = [target integerValue]; // Number
						
						[self showDocumentPage:value]; // Show the page
					}
				}
			}
			else // Nothing active tapped in the target content view
			{
				if (![self.documentDelegate areReaderControlsVisible]) {
					[self.documentDelegate makeReaderControlsVisible:YES animated:YES];
				}
			}
			
			return;
		}
		
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
		
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}
		
		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;
		
		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
		
		CGPoint point = [recognizer locationInView:recognizer.view];
		
		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
		
		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = [[self.dataSource courseDocument].pageNumber integerValue]; // Current page #
			
			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
			
			ReaderContentView *targetView = [_contentViews objectForKey:key];
			
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[targetView zoomIncrement]; break;
				}
					
				case 2: // Two finger double tap: zoom --
				{
					[targetView zoomDecrement]; break;
				}
			}
			
			return;
		}
		
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
		
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}
		
		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;
		
		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

- (void)decrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (self.tag == 0) // Scroll view did end
	{
		NSInteger page = [[self.dataSource courseDocument].pageNumber integerValue];
		NSInteger maxPage = [[self.dataSource courseDocument].pageCount integerValue];
		NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != minPage))
		{
			CGPoint contentOffset = self.contentOffset;
			
			contentOffset.x -= self.bounds.size.width; // -= 1
			
			[self setContentOffset:contentOffset animated:YES];
			
			self.tag = (page - 1); // Decrement page number
		}
	}
}

- (void)incrementPageNumber
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	if (self.tag == 0) // Scroll view did end
	{
		NSInteger page = [[self.dataSource courseDocument].pageNumber integerValue];
		NSInteger maxPage = [[self.dataSource courseDocument].pageCount integerValue];
		NSInteger minPage = 1; // Minimum
		
		if ((maxPage > minPage) && (page != maxPage))
		{
			CGPoint contentOffset = self.contentOffset;
			
			contentOffset.x += self.bounds.size.width; // += 1
			
			[self setContentOffset:contentOffset animated:YES];
			
			self.tag = (page + 1); // Increment page number
		}
	}
}

#pragma mark ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	//	if ((_navBar.hidden == NO) || (_toolbar.hidden == NO))
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
	
	if ([self.documentDelegate areReaderControlsVisible]) {
		[self.documentDelegate makeReaderControlsVisible:NO animated:YES];
	}
	
}

@end
