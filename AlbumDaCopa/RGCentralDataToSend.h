//
//  RGCentralDataToSend.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOT_CONTINUE_SENDING_DATA @"NS"
#define CONTINUE_SENDING_DATA @"CS"
#define CONTINUE_READING_DATA @"CR"
#define NOT_CONTINUE_READING_DATA @"NR"

typedef enum : int {
    Read = 1,
    Write = 2
}Type;

@interface RGCentralDataToSend : NSObject
-(id)initWithDataToSend:(NSData *)data andType:(Type)type;
@property (nonatomic,strong) NSData *dataToSend;
@property (nonatomic) NSUInteger dataToSendIndex;
@property (nonatomic,readonly) BOOL completed;
@property (nonatomic) Type type;

-(NSData *)getNextChunkOfData;
@end
