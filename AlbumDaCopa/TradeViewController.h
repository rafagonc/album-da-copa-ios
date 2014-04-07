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
#import "RGViewTableFollower.h"

@interface TradeViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralManagerDelegate,UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tradeTableView;

#pragma mark - BLUETOOTH
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;
@property (nonatomic,strong) NSMutableArray *devices;


@end
