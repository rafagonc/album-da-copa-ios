//
//  Sticker.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "Sticker.h"


@implementation Sticker

@dynamic userHasIt;
@dynamic name;
@dynamic section;
@dynamic type;
@dynamic index;

#pragma mark - BUILD
-(void)createStickerFromDictionary:(NSDictionary *)stickerDict {
    self.name = stickerDict[@"name"];
    self.section = stickerDict[@"section"];
    self.index = @([stickerDict[@"index"] intValue]);
    self.type = [stickerDict[@"type"] isEqualToString:@"-"]? @"Normal" : stickerDict[@"type"];
    self.userHasIt = 0;
}
+(Sticker *)buildStickerFromDictionary:(NSDictionary *)stickerDict {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    Sticker *s = [[Sticker alloc] initWithEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [s createStickerFromDictionary:stickerDict];
    return s;
}

#pragma mark - STATIC METHODS
+(NSArray *)allStickers {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchR = [[NSFetchRequest alloc] init];
    [fetchR setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    return [context executeFetchRequest:fetchR error:nil];
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
