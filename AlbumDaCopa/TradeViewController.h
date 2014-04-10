//
//  TradeViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceCell.h"
#import "RGBluetooth.h"
#import "TradeController.h"
#define UUID_BLUETOOTH @"2BF1F041-EE1D-4C0E-9242-BC6AE7C45E9E"

@interface TradeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RGBluetoothDelegate> {
    BOOL isPad;
    RGBluetooth *bluetoothManager;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tradeTableView;
@property (weak, nonatomic) IBOutlet UIView *followTable;

#pragma mark - BLUETOOTH
@property (nonatomic) BOOL isSendingData;
@property (nonatomic,strong) NSMutableArray *devices;


@end
