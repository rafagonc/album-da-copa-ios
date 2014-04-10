//
//  TradeController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/9/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeController : NSObject
#pragma mark - INIT
-(id)initWithJSONData:(NSData *)jsonData;

#pragma mark - PROPERTIES
@property (nonatomic,strong) NSArray *receivedStickerArray;
@property (nonatomic,strong) NSMutableArray *stickersIGiveHim;
@property (nonatomic,strong) NSMutableArray *stickersHeGaveMe;


#pragma mark - METHODS
-(NSMutableArray *)startComparingStickersToFindPossibleExchanges;
@end
