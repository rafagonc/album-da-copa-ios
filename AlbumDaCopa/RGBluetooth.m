
//
//  RGBluetooth.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/8/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "RGBluetooth.h"

@implementation RGBluetooth

@synthesize discoverBlock;
@synthesize centralManager;
@synthesize peripheralManager;

-(id)init {
    if (self = [super init]) {
        self.uuid = [CBUUID UUIDWithString:UUID_BLUETOOTH];
    }
    return self;
}

#pragma mark - SCANNING
-(void)startScanning:(DiscoverDevicesBlock)callback {
    self.discoverBlock = callback;
}


#pragma mark - CENTRAL MANAGER DELEGATE
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) return;
    [central scanForPeripheralsWithServices:@[self.uuid] options:nil];
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    self.discoverBlock(@[peripheral]);
}
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
}

#pragma mark - PERIPHERAL DELEGATE



#pragma mark - PERIPHERAL MANAGER DELEGATE
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) return;
    [peripheral startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[self.uuid]}];
}
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
}

@end
