//
//  User.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/4/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - OTHERS
-(id)initFromParse:(NSDictionary *)dict {
    if (self = [super init]) {
        self.email = dict[@"email"];
        self.stickers = dict[@"stickers"];
    }
    return self;
}

#pragma mark - ME
+(User *)me {
    static User*me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[User alloc] init];
        me.email = [[NSUserDefaults standardUserDefaults] objectForKey:EmailUserDefaultString];
        me.stickers = [StickerController allStickers];
    });
    return me;
}

#pragma mark - PARSE
-(void)saveWithCallback:(void (^)(void))callback {
    
}
@end
