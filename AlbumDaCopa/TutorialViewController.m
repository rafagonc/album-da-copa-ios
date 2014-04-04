//
//  TutorialViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/4/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

#pragma mark - INIT
-(id)init {
    self = [super initWithNibName:@"TutorialViewController" bundle:nil];
    if (self) {
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ACTIONS
-(IBAction)next:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
