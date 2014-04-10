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
typedef void (^ProgressBlock)(double progress);

@protocol RGBluetoothDelegate <NSObject>

-(void)peripheralDidReceiveDataFromCentral:(NSData *)data;
-(void)centralDidCompleteSendingDataToPeripheral:(BOOL)success;

@end


#define NOT_CONTINUE_SENDING_DATA @"N"
#define CONTINUE_SENDING_DATA @"C"
#define AMOUNT_OF_CHUNK 20

@interface RGBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate> {
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    NSMutableArray *devices;
    CBMutableCharacteristic *tradeCharacteristic;
    CBMutableService *tradeService;
    CBPeripheral *centralToPeripheral;
    BOOL isPeripheral,isConnected, hasSendData;
    
}

@property (nonatomic,strong) CBUUID *uuid;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;


#pragma mark - BLOCKS
@property (copy) DiscoverDevicesBlock discoverBlock;
@property (copy) ConnectToDeviceBlock connectBlock;
@property (copy) ProgressBlock progressBlock;;

#pragma mark - DELEGATE
@property(nonatomic,strong) id<RGBluetoothDelegate> delegate;


#pragma mark - METHODS
-(id)initWithDataToSent:(NSData *)toSent  andDelegate:(id<RGBluetoothDelegate>)delegate;
-(void)connectToDevice:(CBPeripheral *)peripheral WithCallback:(ConnectToDeviceBlock)callback;
-(void)startScanning:(DiscoverDevicesBlock)callback;
-(void)centralSendDataToPeripheralWithProgress:(ProgressBlock)progress;
@end
