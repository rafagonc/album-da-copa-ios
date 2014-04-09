//
//  RGBluetooth.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/8/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DiscoverDevicesBlock)(NSMutableArray *devices);
typedef void (^ConnectToDeviceBlock)(BOOL success, BOOL isCentral);

#define NOT_CONTINUE_SENDING_DATA @"N"
#define CONTINUE_SENDING_DATA @"C"
#define AMOUNT_OF_CHUNK 200

@interface RGBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate> {
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    NSMutableArray *devices;
    CBMutableCharacteristic *tradeCharacteristic;
    CBMutableService *tradeService;
    BOOL isPeripheral;
    
}

@property (nonatomic,strong) CBUUID *uuid;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;


#pragma mark - BLOCKS
@property (copy) DiscoverDevicesBlock discoverBlock;
@property (copy) ConnectToDeviceBlock connectBlock;



+(RGBluetooth *)sharedManager;
-(void)connectToDevice:(CBPeripheral *)peripheral WithCallback:(ConnectToDeviceBlock)callback;
-(void)startScanning:(DiscoverDevicesBlock)callback;
@end
