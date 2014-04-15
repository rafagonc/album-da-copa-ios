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
    [fetchR setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    return [context executeFetchRequest:fetchR error:nil];
}
+(void)createAllStickersToDatabase {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stickers" ofType:@"json"]];
    NSMutableArray *sticekrs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSData *data2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photos" ofType:@"json"]];
    NSDictionary *photos = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *stickerDict in sticekrs) {
        [Sticker buildStickerFromDictionary:stickerDict andPhotos:photos];
    }
    if (![context save:nil]) {
        NSAssert(0,@"Error On Saving Stickers JSON");
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:NotFirstTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
+(NSArray *)findLeftoversAvaliable {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchR = [[NSFetchRequest alloc] init];
    [fetchR setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    [fetchR setPredicate:[NSPredicate predicateWithFormat:@"leftovers > 0"]];
    [fetchR setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    return [context executeFetchRequest:fetchR error:nil];
}
+(NSArray *)toGet {
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchR = [[NSFetchRequest alloc] init];
    [fetchR setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    [fetchR setPredicate:[NSPredicate predicateWithFormat:@"onAlbum == 0"]];
    [fetchR setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    return [context executeFetchRequest:fetchR error:nil];
}



#pragma mark - TRANSFROM INTO JSON
+(NSData *)jsonFromAllStickers {
    NSArray *allStickers = [StickerController allStickers];
    NSMutableArray *newStickersWithDictsInsteadOfObjects = [[NSMutableArray alloc] initWithCapacity:allStickers.count];
    for (Sticker *s in allStickers) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:s.index, @"index", s.leftovers, @"leftovers" , s.onAlbum , @"onAlbum", s.type , @"type", nil];
        [newStickersWithDictsInsteadOfObjects addObject:dict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:newStickersWithDictsInsteadOfObjects options:NSJSONWritingPrettyPrinted error:nil];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [[s dataUsingEncoding:NSUTF8StringEncoding] gzippedDataWithCompressionLevel:1];
}


@end
