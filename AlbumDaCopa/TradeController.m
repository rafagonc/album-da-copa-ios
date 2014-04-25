//
//  TradeController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/9/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeController.h"

@interface TradeController () {
    BOOL jsonReadingErrorRaised;
}
@end

@implementation TradeController
-(id)initWithJSONData:(NSArray *)jsonData {
    if (self = [super init]) {
        self.stickersHeGaveMe = [[NSMutableArray alloc] init];
        self.stickersIGiveHim = [[NSMutableArray alloc] init];
        NSError *error;
        self.receivedStickerArray = jsonData;
        if (error) {
            jsonReadingErrorRaised = YES;
        }
    } return self;
}
-(NSMutableArray *)startComparingStickersToFindPossibleExchanges {
    NSArray *myStickers = [StickerController allStickers];
    self.myLeftovers = [StickerController findLeftoversAvaliable];;
    self.hisLeftovers = [self findHisLeftoversAvalible];

    
    for (NSDictionary *dict in self.hisLeftovers) {
        Sticker *sticker = myStickers[[dict[@"index"] intValue]];
        if (!sticker.onAlbum.boolValue) {
            [self.stickersHeGaveMe addObject:[NSDictionary dictionaryWithObjectsAndKeys:sticker.index,@"index",sticker.type,@"type" ,nil]];
        }
    }
    
    for (Sticker *sticker in self.myLeftovers) {
        NSDictionary *dict = self.receivedStickerArray[sticker.index.intValue];
        if (![dict[@"onAlbum"] boolValue]) {
            [self.stickersIGiveHim addObject:[NSDictionary dictionaryWithObjectsAndKeys:dict[@"index"],@"index",dict[@"type"],@"type" ,nil]];
        }
    }
    NSMutableArray *allExchanges = [self compareAndMakeTheCorrectExchangesWithAllSticker:myStickers];
    return allExchanges;
}
-(NSMutableArray *)compareAndMakeTheCorrectExchangesWithAllSticker:(NSArray *)allStickers {
    NSMutableArray *allExchanges = [[NSMutableArray alloc] init];

    NSPredicate *predForMetal = [NSPredicate predicateWithFormat:@"(type == metal)"];
    NSArray *myMetalsToExchange = [self.stickersIGiveHim filteredArrayUsingPredicate:predForMetal];
    NSArray *metalsHeHas = [self.stickersHeGaveMe filteredArrayUsingPredicate:predForMetal];
    NSUInteger metalCount = myMetalsToExchange.count >= metalsHeHas.count? metalsHeHas.count : myMetalsToExchange.count;
    
    for (int i = 0; i < metalCount; i++) {
        NSDictionary *stickerToGive = myMetalsToExchange[i];
        NSDictionary *stickerToReceive = metalsHeHas[i];
        NSDictionary * finalExchangeDict = [NSDictionary dictionaryWithObjectsAndKeys:stickerToGive[@"index"], @"give", stickerToReceive[@"index"], @"receive" ,nil];
        [allExchanges addObject:finalExchangeDict];
    }
    
    
    NSPredicate *predForNormal = [NSPredicate predicateWithFormat:@"(type != metal)"];
    NSArray *myNormalsToExchange = [self.stickersIGiveHim filteredArrayUsingPredicate:predForNormal];
    NSArray *normalsHeHas = [self.stickersHeGaveMe filteredArrayUsingPredicate:predForNormal];
    NSUInteger normalCount = myNormalsToExchange.count >= normalsHeHas.count? normalsHeHas.count : myNormalsToExchange.count;
    
    for (int i = 0; i < normalCount; i++) {
        NSDictionary *stickerToGive = myNormalsToExchange[i];
        NSDictionary *stickerToReceive = normalsHeHas[i];
        NSDictionary * finalExchangeDict = [NSDictionary dictionaryWithObjectsAndKeys:stickerToGive[@"index"], @"give", stickerToReceive[@"index"], @"receive" ,nil];
        [allExchanges addObject:finalExchangeDict];
    }

    
    return allExchanges;
}
-(NSArray *)findHisLeftoversAvalible {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(leftovers > 0)"];
    return [self.receivedStickerArray filteredArrayUsingPredicate:pred];
}
@end
