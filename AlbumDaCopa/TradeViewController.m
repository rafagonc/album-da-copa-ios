//
//  TradeViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeViewController.h"

@interface TradeViewController ()
@property (nonatomic,strong) CBUUID *uuid;
@property (nonatomic,strong) CBPeripheral *connectedPeripheral;
@property (nonatomic,strong) CBMutableService *service;
@property (nonatomic,strong) CBMutableCharacteristic *serviceCharacteristic;
@end

@implementation TradeViewController

#pragma mark - INIT
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"TradeViewController" bundle:nil];
    if (self) {
    }
    return self;
}

#pragma mark - VIEW
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupBluetooth];
    [self decorator];
    
}
-(void)viewDidDisappear:(BOOL)animated {
}
-(void)setupTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;
}
-(void)setupBluetooth {
    [self.activity startAnimating];
    self.uuid = [CBUUID UUIDWithString:UUID_BLUETOOTH];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:20  completion:^(NSArray *peripherals) {
         if (peripherals.count) {
             [self.devices addObjectsFromArray:peripherals];
             [self.tradeTableView reloadData];
         }
     }];
}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.tradeTableView.tableHeaderView.backgroundColor = flatBlue;
    self.followTable.backgroundColor = flatBlue;
}


#pragma mark BLUETOOTH
-(void)activateBluetoothForDevice:(LGPeripheral *)peripheral {
    [peripheral connectWithCompletion:^(NSError *error) {
        [self.activity stopAnimating];
        NSLog(@"connected");
    }];
}


#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DeviceCell" owner:self options:nil][0];
    }
    
    LGPeripheral *peri = self.devices[indexPath.row];
    cell.deviceName.text = peri.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LGPeripheral *peri = self.devices[indexPath.row];
    [self activateBluetoothForDevice:peri];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) return;
    self.followTable.frame = CGRectMake(self.followTable.frame.origin.x, self.followTable.frame.origin.y, self.followTable.frame.size.width, -scrollView.contentOffset.y);
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
