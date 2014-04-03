//
//  CameraViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCaptureSessionManager.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <Accelerate/Accelerate.h>
@interface CameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {
    int countPhotos;
    UIImageView *imageView;
}

#pragma mark - PROPERTIES
@property (nonatomic,strong) AVCaptureSessionManager *captureManager;
@property (nonatomic,strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic) BOOL finishedFocusing;
@property (nonatomic,strong) UIImage *currentImage;

@end
