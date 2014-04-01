//
//  Sticker.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "Sticker.h"


@implementation Sticker

@dynamic onAlbum;
@dynamic name;
@dynamic section;
@dynamic type;
@dynamic index;
@dynamic leftovers;

#pragma mark - BUILD
-(void)createStickerFromDictionary:(NSDictionary *)stickerDict {
    self.name = stickerDict[@"name"];
    self.section = stickerDict[@"section"];
    self.index = @([stickerDict[@"index"] intValue]);
    self.type = [stickerDict[@"type"] isEqualToString:@"-"]? @"Normal" : stickerDict[@"type"];
    self.onAlbum = @0;
    self.leftovers = @0;
}
+(Sticker *)buildStickerFromDictionary:(NSDictionary *)stickerDict {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    Sticker *s = [[Sticker alloc] initWithEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [s createStickerFromDictionary:stickerDict];
    return s;
}



@end
