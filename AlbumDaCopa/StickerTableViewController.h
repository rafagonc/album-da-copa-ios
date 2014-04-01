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

#define ChangedStatsNotification @"changedStats"

@interface StickerTableViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

#pragma mark - PROPERTIES
@property (nonatomic,strong) NSArray *stickers;

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *percentCompletedLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStickersToBeCompletedLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *statusBarCover;

#pragma mark - METHODS
-(id)init;


@end
