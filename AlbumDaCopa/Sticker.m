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

#pragma mark - STATIC METHODS
+(NSMutableDictionary *)allStickers {
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchR = [[NSFetchRequest alloc] init];
    [fetchR setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    //ORGANIZE INTO SECTIONS
    for (Sticker *sticker in [context executeFetchRequest:fetchR error:nil]) {
        if (returnDict[sticker.section]) {
            NSMutableArray *oldStickerArray = returnDict[sticker.section];
            [oldStickerArray addObject:sticker];
            
        } else {
            NSMutableArray *newStickerArray = [[NSMutableArray alloc] init];
            [newStickerArray addObject:sticker];
            [returnDict setObject:newStickerArray forKey:sticker.section];
        }
    }
    
    return returnDict;
}

#pragma mark - FIRST TIME SAVE ALL
+(void)createAllStickersToDatabase {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stickers" ofType:@"json"]];
    NSMutableArray *sticekrs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *stickerDict in sticekrs) {
        [Sticker buildStickerFromDictionary:stickerDict];
    }
    if ([context save:nil]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:NOTFIRSTTIME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSAssert(0,@"Error On Saving Stickers JSON");
    }
}
@end
