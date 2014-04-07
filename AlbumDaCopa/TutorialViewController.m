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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finish) name:FinishTutorialNotification object:nil];
}

#pragma mark - ACTIONS
-(IBAction)next:(id)sender {
    [self finish];
}
-(void)finish {
    [self dismissViewControllerAnimated:1 completion:nil];
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
