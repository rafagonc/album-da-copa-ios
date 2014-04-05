//
//  User.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/4/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSArray *stickers;



+(User *)me ;
@end
