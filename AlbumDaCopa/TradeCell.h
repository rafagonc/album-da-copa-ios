//
//  TradeCell.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *inChangeIndex;

@property (weak, nonatomic) IBOutlet UILabel *inChangeOfName;
@property (weak, nonatomic) IBOutlet UILabel *myStickerIndex;
@property (weak, nonatomic) IBOutlet UILabel *myStickerName;
@end
