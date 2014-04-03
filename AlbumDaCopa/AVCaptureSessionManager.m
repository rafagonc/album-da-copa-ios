//
//  AVCaptureSessionManager.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "AVCaptureSessionManager.h"

@implementation AVCaptureSessionManager
@synthesize captureSession;
@synthesize previewLayer;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}
- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}
- (void)addVideoInput {
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self configureCameraForLowestFrameRate:videoDevice];
	if (videoDevice) {
		NSError *error;
		self.videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];


		if (!error) {
			if ([self.captureSession canAddInput:self.videoIn])
				[self.captureSession addInput:self.videoIn];
            
            
                
				NSLog(@"Couldn't add video input");
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}
- (void)configureCameraForLowestFrameRate:(AVCaptureDevice *)device {
    
    AVCaptureDeviceFormat *lowFormat = nil;
    
    AVFrameRateRange *lowFrameRateRange = nil;
    
    for ( AVCaptureDeviceFormat *format in [device formats] ) {
        
        for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
            
            if ( range.maxFrameRate < lowFrameRateRange.maxFrameRate ) {
                
                lowFormat = format;
                
                lowFrameRateRange = range;
                
            }
            
        }
        
    }
    
    if ( lowFormat ) {
        
        if ( [device lockForConfiguration:NULL] == YES ) {
            
            device.activeFormat = lowFormat;
            
            device.activeVideoMinFrameDuration = lowFrameRateRange.minFrameDuration;
            
            device.activeVideoMaxFrameDuration = lowFrameRateRange.minFrameDuration;
            
            [device unlockForConfiguration];
            
        }
        
    }
    
}
- (void)dealloc {
	[[self captureSession] stopRunning];

}
@end
