//
//  StickerCell.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"
@interface StickerCell : UITableViewCell <UITextFieldDelegate>

#pragma mark - PROPERTIES
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UITextField *leftoversButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic ) IBOutlet UILabel *typeLabel;

@property (nonatomic) BOOL hasIt;
@property (nonatomic) BOOL stickerHasChanges;

@property (nonatomic,strong) Sticker *sticker;

@end
