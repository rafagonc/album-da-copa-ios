//
//  TradeSystemTutorialViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/4/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeSystemTutorialViewController.h"

@interface TradeSystemTutorialViewController ()

@end

@implementation TradeSystemTutorialViewController

#pragma mark - INIT
- (id)init {
    self = [super initWithNibName:@"TradeSystemTutorialViewController" bundle:nil];
    if (self) {
    }
    return self;
}

#pragma mark - VIEW
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.emailTextField becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ACTIONS
- (IBAction)finalizar:(id)sender {
    if (!self.emailTextField.text.length  || ![self IsValidEmail:self.emailTextField.text Strict:YES]) {
        self.helpString.text = @"Digite um e-mail válido";
        self.helpString.textColor = [UIColor redColor];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:EmailUserDefaultString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FinishTutorialNotification object:nil userInfo:nil];

    }];
}

#pragma mark - VALIDATOR
-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark - DEALLOC
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
