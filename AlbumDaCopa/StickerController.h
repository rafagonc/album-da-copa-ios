//
//  StickerController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickerController : NSObject
+(NSArray *)allStickers;
+(void)createAllStickersToDatabase;
+(NSArray *)statsForTheAlbum;
@end