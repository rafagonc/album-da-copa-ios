//
//  RGBluetoothData.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {Write = 0, Read = 1}Type;
@interface RGBluetoothData : NSObject
-(id)initWithData:(NSData *)data andType:(Type)type;
@property (nonatomic,strong) NSData *data;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic) NSUInteger dataIndex;
@property (nonatomic,readonly) BOOL completed;
@property (nonatomic) Type type;
@property (nonatomic) double progress;
-(NSData *)nextChunkOfData;

@end
