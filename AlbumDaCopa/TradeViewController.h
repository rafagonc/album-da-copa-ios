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

@interface TradeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MCBrowserViewControllerDelegate,MCSessionDelegate> {
    BOOL isPad;
    BOOL isConnected;
}


@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tradeTableView;
@property (nonatomic,strong) NSArray *neededStickers;
@property (weak, nonatomic) IBOutlet UIView *followTable;
@property (nonatomic,strong) NSMutableArray *tradeData;

#pragma mark - BLUETOOTH
@property (nonatomic) BOOL isSendingData;
@property (nonatomic,strong) NSMutableArray *devices;


@end
