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
@interface CameraViewController : UIViewController

#pragma mark - PROPERTIES
@property (nonatomic,strong) AVCaptureSessionManager *captureManager;

@end
