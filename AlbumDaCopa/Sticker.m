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
@dynamic bagdeImageName;
@dynamic countryImageName;
@dynamic section;
@dynamic type;
@dynamic index;
@dynamic leftovers;
@dynamic dateAdded;

#pragma mark - CODING
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.onAlbum = [aDecoder decodeObjectForKey:@"onAlbum"];
        self.leftovers = [aDecoder decodeObjectForKey:@"leftovers"];
        self.index = [aDecoder decodeObjectForKey:@"index"];
    } return self;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.onAlbum forKey:@"onAlbum"];
    [aCoder encodeObject:self.leftovers forKey:@"leftovers"];
    [aCoder encodeObject:self.index forKey:@"index"];
}

#pragma mark - BUILD
-(void)createStickerFromDictionary:(NSDictionary *)stickerDict andPhotos:(NSDictionary *)photosDict {
    self.name = stickerDict[@"name"];
    self.section = stickerDict[@"section"];
    self.index = @([stickerDict[@"index"] intValue]);
    self.type = [stickerDict[@"type"] isEqualToString:@"-"]? @"Normal" : stickerDict[@"type"];
    self.onAlbum = @0;
    self.leftovers = @0;
    self.bagdeImageName = photosDict[stickerDict[@"section"]][@"bagde"];
    self.countryImageName = photosDict[stickerDict[@"section"]][@"flag"];
    
    if (!photosDict[stickerDict[@"section"]] ) {
        if ([stickerDict[@"section"] isEqualToString:@"Introdução"] || [stickerDict[@"section"] isEqualToString:@"Estádios"]) return;
        NSAssert(0,@"Arruma Photos JSON - %@", stickerDict[@"section"]);
    }
 
    
    
}
+(Sticker *)buildStickerFromDictionary:(NSDictionary *)stickerDict andPhotos:(NSDictionary *)photosDict {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    Sticker *s = [[Sticker alloc] initWithEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [s createStickerFromDictionary:stickerDict andPhotos:photosDict];
    return s;
}





@end
