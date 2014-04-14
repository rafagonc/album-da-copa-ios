//
//  StickerTableViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"
#import "StickerCell.h"
#import "StickerController.h"
#import <iAd/iAd.h>
#import "IntroductionTableViewHeader.h"
#import "TutorialViewController.h"
#import "StatusAndSearchTableViewHeader.h"
#import <AdColony/AdColony.h>
#import "Up.h"
#define ChangedStatsNotification @"changedStats"
#define ReloadTableNotification @"reloadTable"
#define ADCOLONY__ZONE @"vz5be979460cde4b7c8f"

@interface StickerTableViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate> {
    UIButton *doneOrTradeButton;
    BOOL isPad;
}

#pragma mark - PROPERTIES
@property (nonatomic,strong) NSArray *stickers;
@property (nonatomic) BOOL shouldBeginIntroduction;

#pragma mark - OUTLETS
@property (nonatomic,strong) Up *upView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *statusBarCover;
@property (weak, nonatomic) IBOutlet UIView *sliderHandlerView;
@property (strong, nonatomic) StatusAndSearchTableViewHeader *normalHeader;

#pragma mark - METHODS
-(id)init;
-(void)showAd;


@end
