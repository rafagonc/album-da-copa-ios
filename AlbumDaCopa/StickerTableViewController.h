//
//  StickerTableViewController.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"
#import "StickerCell.h"
@interface StickerTableViewController : UITableViewController

#pragma mark - PROPERTIES
@property (nonatomic,strong) NSMutableDictionary *stickers;

#pragma mark - METHODS
-(id)init;


@end
