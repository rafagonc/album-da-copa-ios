//
//  TradeViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TradeCell.h"
#import "TradeController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "JLActionSheet.h"
#import "ExplanationCell.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"

#define TradeStringAction @"trade"
#define CopyStringAction @"copy"


@interface TradeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MCBrowserViewControllerDelegate,MCSessionDelegate> {
    BOOL isConnected;
    BOOL isPad;
}


@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic) MultipeerAction mAction;
@property (weak, nonatomic) IBOutlet UITableView *tradeTableView;
@property (nonatomic,strong) NSArray *neededStickers;
@property (weak, nonatomic) IBOutlet UIView *followTable;
@property (nonatomic,strong) NSMutableArray *tradeData;



@end
