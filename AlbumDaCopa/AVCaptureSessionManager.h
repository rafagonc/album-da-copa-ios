//
//  AVCaptureSessionManager.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVCaptureSessionManager : NSObject {
    UIImage *currentImage;
}
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property AVCaptureDeviceInput *videoIn;
- (void)addVideoPreviewLayer;
- (void)addVideoInput;
@end
