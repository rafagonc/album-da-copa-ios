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
@property (nonatomic,strong) CBMutableCharacteristic *serviceCharacteristic;
@property (nonatomic,strong) CBMutableService *service;
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
    [self setupBluetooth];
    [self setupTableView];
    [self decorator];
    
    RGViewTableFollower *follow = [[RGViewTableFollower alloc] init]
}
-(void)setupTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;
}
-(void)setupBluetooth {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    
    self.uuid = [CBUUID UUIDWithString:@"2BF1F041-EE1D-4C0E-9242-BC6AE7C45E9E"];
    self.serviceCharacteristic = [[CBMutableCharacteristic alloc] initWithType:self.uuid properties:CBCharacteristicPropertyRead value:[NSData data] permissions:CBAttributePermissionsReadable];
    self.service = [[CBMutableService alloc] initWithType:self.uuid primary:YES];
    self.service.characteristics = @[self.serviceCharacteristic];
    [self.peripheralManager addService:self.service];
    self.devices = [[NSMutableArray alloc] init];
    [self.centralManager performSelector:@selector(stopScan) withObject:nil afterDelay:60];
}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.tradeTableView.tableHeaderView.backgroundColor = flatBlue;

}


#pragma mark - CENTRAL DELEGATE
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI floatValue]>=-45.f) {
        [self.devices addObject:peripheral];
        [self.tradeTableView reloadData];
        [central stopScan];
    }
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if(central.state==CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [self.activity startAnimating];
    }
}

#pragma mark - PERIPHERAL DELEGATE
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if(peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[self.service.UUID], CBAdvertisementDataLocalNameKey : [[UIDevice currentDevice] name]}];
    }
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


#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
