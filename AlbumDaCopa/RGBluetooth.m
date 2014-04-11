
//
//  RGBluetooth.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/8/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "RGBluetooth.h"

@interface RGBluetooth ()
@property (strong,nonatomic) RGBluetoothData *centralDataToSend;
@property (strong,nonatomic) RGBluetoothData *centralDataToReceive;

@end

@implementation RGBluetooth

@synthesize centralManager;
@synthesize peripheralManager;

#pragma mark - INIT
-(id)initWithDataToSent:(NSData *)toSent1 andDelegate:(id<RGBluetoothDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.uuid = [CBUUID UUIDWithString:UUID_BLUETOOTH];
        self.centralManager  = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        self.centralDataToReceive = [[RGBluetoothData alloc] initWithData:[NSData data] andType:Write];
        toSent = toSent1;
        isPeripheral = NO;
        hasSendData = NO;
    }
    return self;
}

#pragma mark - SCANNING
-(void)startScanning:(DiscoverDevicesBlock)callback {
    devices = [[NSMutableArray alloc] init];
    self.discoverBlock = callback;
}
-(void)connectToDevice:(CBPeripheral *)peripheral WithCallback:(ConnectToDeviceBlock)callback {
    self.centralDataToSend = [[RGBluetoothData alloc] initWithData:[toSent gzippedDataWithCompressionLevel:1] andType:Write];
    [self.centralManager connectPeripheral:peripheral options:nil];
    self.connectBlock = callback;
}
-(void)centralSendDataToPeripheralWithProgress:(ProgressBlock)progress {
    if (!isConnected) return;
    self.progressBlock = progress;
    [centralToPeripheral discoverServices:@[self.uuid]];
    [self performSelector:@selector(failToSendData) withObject:nil afterDelay:40];
}

#pragma mark - CENTRAL MANAGER DELEGATE
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) return;
    [central scanForPeripheralsWithServices:@[self.uuid] options:nil];
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![devices containsObject:peripheral]) {
        [devices addObject:peripheral];
        self.discoverBlock(devices);
    }
}
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    isConnected = YES;
    [self.peripheralManager stopAdvertising];
    [self.centralManager stopScan];
    centralToPeripheral = peripheral;
    peripheral.delegate = self;
    self.connectBlock(YES,YES);

}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    isConnected = NO;
    self.connectBlock(NO,YES);
}

#pragma mark PERIPHERAL DELEGATE
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *svc in peripheral.services) {
        [peripheral discoverCharacteristics:@[self.uuid] forService:svc];
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *charac in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:charac];
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    [peripheral writeValue:[self.centralDataToSend nextChunkOfData] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSString *s = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if ([s isEqualToString:CONTINUE_SENDING_DATA]) {
        self.progressBlock(self.centralDataToSend.progress);
        [peripheral writeValue:[self.centralDataToSend nextChunkOfData] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } else if ([s isEqualToString:NOT_CONTINUE_READING_DATA]) {
        NSLog(@"finished");
    } else {
        [self.centralDataToSend.receivedData appendData:characteristic.value];
        [peripheral writeValue:[NOT_CONTINUE_SENDING_DATA dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        [self.delegate centralDidCompleteSendingDataToPeripheral:YES];
    }

}

#pragma mark - PERIPHERAL MANAGER DELEGATE
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) return;
    
    tradeService = [[CBMutableService alloc] initWithType:self.uuid primary:YES];
    tradeCharacteristic = [[CBMutableCharacteristic alloc] initWithType:self.uuid properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    tradeService.characteristics = @[tradeCharacteristic];
    
    [peripheral addService:tradeService];
    [peripheral startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[self.uuid], CBAdvertisementDataLocalNameKey : [[UIDevice currentDevice] name]}];
}
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    [self.centralManager stopScan];
    isPeripheral = YES;
    
}
-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    CBATTRequest *request = requests[0];
    NSString *s = [[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding];
    if (s && [s isEqualToString:NOT_CONTINUE_SENDING_DATA]) {
        self.centralDataToReceive.data = [[self.delegate peripheralDidReceiveDataFromCentral:[self.centralDataToSend.receivedData gunzippedData]] gzippedDataWithCompressionLevel:1];
        if (!self.centralDataToReceive.completed) [peripheral updateValue:[self.centralDataToSend nextChunkOfData] forCharacteristic:(CBMutableCharacteristic *)request.characteristic onSubscribedCentrals:nil];
        else [peripheral updateValue:[NOT_CONTINUE_READING_DATA dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)request.characteristic onSubscribedCentrals:nil];
        [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        return;
    }
    [self.centralDataToSend.receivedData appendData:request.value];
    [peripheral updateValue:[CONTINUE_SENDING_DATA dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)request.characteristic onSubscribedCentrals:nil];
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];

}

#pragma mark - DATA

-(void)failToSendData {
    if (!hasSendData) {
        [self.centralManager cancelPeripheralConnection:centralToPeripheral];
        [self.delegate centralDidCompleteSendingDataToPeripheral:NO];
    }
}





@end
