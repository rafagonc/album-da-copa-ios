//
//  StickerController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StickerController.h"

@implementation StickerController


#pragma mark - STATIC METHODS
+(NSArray *)allStickers {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchR = [[NSFetchRequest alloc] init];
    [fetchR setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    NSArray *resultArray = [context executeFetchRequest:fetchR error:nil];
    NSArray *sortedArray = [resultArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(Sticker *obj1, Sticker *obj2) {
        return [obj1.index compare:obj2.index];
    }];
    
    return sortedArray;
}
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
+(NSArray *)statsForTheAlbum {
    NSArray *all = [StickerController allStickers];
    double has = 0;
    for (Sticker *sticker in all) {
        has += sticker.onAlbum.boolValue;
    }
    return @[@(has/all.count*100), @(has)];
}

@end
