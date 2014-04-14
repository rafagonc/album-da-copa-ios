//
//  TradeCell.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeCell : UITableViewCell

#pragma mark - UI PROPETIES
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *givingIndex;

@property (weak, nonatomic) IBOutlet UILabel *receivingName;
@property (weak, nonatomic) IBOutlet UILabel *receivingIndex;
@property (weak, nonatomic) IBOutlet UILabel *givingName;


#pragma mark - CODE PROPERtIES
@property (nonatomic) BOOL changeIsDone;
@property (nonatomic,strong) Sticker *givingSticker;
@property (nonatomic,strong) Sticker *receivingSticekr;
@end
