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
    self = [super initWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"TradeViewController-iPad" : @"TradeViewController" bundle:nil];
    if (self) {
        isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
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
-(void)setupTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;
}
-(void)setupBluetooth {
    [self.activity startAnimating];
    self.uuid = [CBUUID UUIDWithString:UUID_BLUETOOTH];
    [[RGBluetooth sharedManager] startScanning:^(NSMutableArray *devices) {
        self.devices = devices;
        [self.tradeTableView reloadData];
    }];

}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.tradeTableView.tableHeaderView.backgroundColor = flatBlue;
    self.followTable.backgroundColor = flatBlue;
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
    
    CBPeripheral *peri = self.devices[indexPath.row];
    cell.deviceName.text = peri.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peri = self.devices[indexPath.row];
    [[RGBluetooth sharedManager] connectToDevice:peri WithCallback:^(BOOL success, BOOL isCentral) {
        if (success) {
            [self.activity stopAnimating];
        }
    }];

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
