//
//  TradeRequest.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeRequest.h"

@implementation TradeRequest

-(id)initWithMeRequestingUserEmail:(NSString *)email {
    if (self = [super init]) {
        self.receivingUserEmail = email;
    } return self;
}

#pragma mark BUILD
+(TradeRequest *)createTradeRequestToUserWithEmail:(NSString *)email {return nil;}


@end
