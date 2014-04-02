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

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:@"CameraViewController" bundle:nil]) {
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCameraPreview];
    [self setUpViews];
    
}
-(void)setUpCameraPreview {
    [self setCaptureManager:[[AVCaptureSessionManager alloc] init]];
	[self.captureManager addVideoInput];
	[self.captureManager addVideoPreviewLayer];
	[self.captureManager.previewLayer setBounds:self.view.layer.bounds];
	[self.captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(self.view.layer.bounds),CGRectGetMidY(self.view.layer.bounds))];
	[self.view.layer addSublayer:self.captureManager.previewLayer];
    [self.captureManager.captureSession startRunning];
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
