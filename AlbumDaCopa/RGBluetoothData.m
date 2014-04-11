//
//  RGBluetoothData.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "RGBluetoothData.h"

@implementation RGBluetoothData
-(id)initWithData:(NSData *)data andType:(Type)type {
    if (self = [super init]) {
        self.data = data;
        self.dataIndex = 0;
        self.type = type;
        self.receivedData = [[NSMutableData alloc] init];
    }
    return self;
}
-(BOOL)completed {
    return self.dataIndex >= self.data.length;
}
-(double)progress {
    return (double)self.dataIndex/(double)self.data.length;
}
-(NSData *)nextChunkOfData {
    if (self.completed) {
        return [NOT_CONTINUE_SENDING_DATA dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSData *chunk = [NSData dataWithBytes:self.data.bytes+self.dataIndex length:AMOUNT_OF_CHUNK];
    self.dataIndex += AMOUNT_OF_CHUNK;
    return chunk;
}
@end
