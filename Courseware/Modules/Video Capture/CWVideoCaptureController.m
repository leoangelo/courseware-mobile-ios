//
//  CWVideoCaptureController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWVideoCaptureController.h"
#import "CWUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "CWThemeHelper.h"
#import "CWConstants.h"	
#import <MobileCoreServices/UTCoreTypes.h>

@interface CWVideoCaptureController ()

@property (nonatomic, strong) UIImagePickerController *videoRecorder;

- (UIView *)videoInstructions;

@end

@implementation CWVideoCaptureController

- (void)launchVideoCapture
{
	self.videoRecorder = [[UIImagePickerController alloc] init];
	self.videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.videoRecorder.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
	self.videoRecorder.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	self.videoRecorder.showsCameraControls = YES;
	self.videoRecorder.videoQuality = UIImagePickerControllerQualityTypeLow;
	self.videoRecorder.cameraOverlayView = [self videoInstructions];
	
	[[CWUtilities getTopViewController] presentViewController:self.videoRecorder animated:YES completion:^{}];
}

- (UIView *)videoInstructions
{
	UILabel *label = [[UILabel alloc] init];
	label.text = @"Demonstrate 10 different hand signals in landing aircraft.";
	label.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
	label.alpha = 0.8;
	label.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	label.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	[label sizeToFit];
	label.textAlignment = UITextAlignmentCenter;
	
	label.frame = (CGRect) {
		10, 10, label.frame.size.width + 8, label.frame.size.height + 8
	};
	
	label.layer.masksToBounds = YES;
	label.layer.cornerRadius = 3.f;
	
	return label;
}

@end
