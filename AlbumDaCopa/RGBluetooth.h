//
//  RGBluetooth.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/8/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DiscoverDevicesBlock)(NSArray *devices);


@interface RGBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate> {
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    
    DiscoverDevicesBlock discoverBlock;
}

@property (nonatomic,strong) CBUUID *uuid;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;


#pragma mark - BLOCKS
@property (nonatomic,strong) DiscoverDevicesBlock discoverBlock;
@end
