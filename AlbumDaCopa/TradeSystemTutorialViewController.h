//
//  TradeSystemTutorialViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/4/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FinishTutorialNotification @"finishTutorial"
#define EmailUserDefaultString @"email"
@interface TradeSystemTutorialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpString;
@end
