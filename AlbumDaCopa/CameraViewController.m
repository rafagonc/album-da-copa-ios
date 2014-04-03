//
//  CameraViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

#pragma mark - INIT AND SETUP
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:@"CameraViewController" bundle:nil]) {
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    countPhotos = 0;
    [self setUpCameraPreview];
    [self setUpViews];
    
}
-(void)setUpCameraPreview {
    //ADD {REVIEW AND INPUT
    [self setCaptureManager:[[AVCaptureSessionManager alloc] init]];
	[self.captureManager addVideoInput];
	[self.captureManager addVideoPreviewLayer];
	[self.captureManager.previewLayer setBounds:self.view.layer.bounds];
	[self.captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(self.view.layer.bounds),CGRectGetMidY(self.view.layer.bounds))];
	[self.view.layer addSublayer:self.captureManager.previewLayer];
    [self.captureManager.captureSession startRunning];
    [[[self.captureManager videoIn] device] addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    AVCaptureVideoDataOutput *dataOutput = [AVCaptureVideoDataOutput new];
    dataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [dataOutput setMinFrameDuration:CMTimeMake(0, 8)];
    
  
    
    
    if ( [self.captureManager.captureSession canAddOutput:dataOutput]) [self.captureManager.captureSession addOutput:dataOutput];
    self.dataOutput = dataOutput;
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    [self.dataOutput setSampleBufferDelegate:self queue:queue];
    
    
}
-(void)setUpViews {
    UIButton *cancelButton = ({
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 30, 50, 50)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [cancelButton.titleLabel setTextColor:[UIColor whiteColor]];
        [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        cancelButton;
    });
    
    imageView = ({
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 80, 100)];
        [self.view addSubview:imageView];
        imageView;
    });
    


}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    BOOL focusing;
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (adjustingFocus) {
            focusing = YES;
            self.finishedFocusing = NO;
        }
        else {
            if (focusing) {
                focusing = NO;
                self.finishedFocusing = YES;
            }
        }
    }
}


#pragma mark - CAPTURE
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    
    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    Pixel_8 *lumaBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace, kCGBitmapByteOrderDefault);
    CGImageRef dstImage = CGBitmapContextCreateImage(context);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.captureManager.previewLayer.contents = (__bridge id)dstImage;
        if (self.finishedFocusing) {
            self.currentImage = [UIImage imageWithCGImage: dstImage ];
        }

    });
    
    CGImageRelease(dstImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
}


#pragma mark - ACTIONS
-(void)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DEALLOC
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
