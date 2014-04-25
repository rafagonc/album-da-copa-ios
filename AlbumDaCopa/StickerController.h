//
//  StickerController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/1/14.
//  Copyright (c) 2014 Rafael ;. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NotFirstTime @"NotFirstTime"
#import "GZIP.h"

typedef enum : int {
    Copy = 0,
    Trade = 1
}MultipeerAction;

@interface StickerController : NSObject
+(NSArray *)allStickers;
+(void)createAllStickersToDatabase;
+(NSData *)jsonFromAllStickers:(MultipeerAction)action;
+(NSArray *)findLeftoversAvaliable;
+(NSArray *)statsForTheAlbum;
+(NSArray *)toGet;
+(void)deleteAllAlbum;
@end
