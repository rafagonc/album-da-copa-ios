//
//  RGCentralDataToSend.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "RGCentralDataToSend.h"

@implementation RGCentralDataToSend
-(id)initWithDataToSend:(NSData *)data andType:(Type)type {
    if (self = [super init]) {
        self.dataToSend = data;
        self.dataToSendIndex = 0;
        self.type = type;
    } return self;
}

#pragma mark METHODS
-(BOOL)completed {
    return self.dataToSendIndex >= self.dataToSend.length;
}
-(NSData *)getNextChunkOfData {
    if (self.completed) {
        return [self.type == Write? NOT_CONTINUE_SENDING_DATA : NOT_CONTINUE_READING_DATA dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.dataToSendIndex length:AMOUNT_OF_CHUNK];
    self.dataToSendIndex += AMOUNT_OF_CHUNK;
    return chunk;
}
@end
