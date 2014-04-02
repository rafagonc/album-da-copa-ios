//
//  Sticker.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Sticker.h"
;
#define NOTFIRSTTIME @"first"

@interface Sticker : NSManagedObject

@property (nonatomic, retain) NSNumber * onAlbum;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * leftovers;


#pragma mark - METHODS
+(Sticker *)buildStickerFromDictionary:(NSDictionary *)stickerDict;
@end