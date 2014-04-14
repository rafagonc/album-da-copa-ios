//
//  TradeCell.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/10/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeCell.h"

@implementation TradeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.changeIsDone = NO;
    }
    return self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(IBAction)checkButton:(id)sender {
    self.changeIsDone = !self.changeIsDone;
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    self.givingSticker.leftovers = [NSNumber numberWithInt:self.givingSticker.leftovers.intValue + (self.changeIsDone? -1 : 1)];
    self.receivingSticekr.onAlbum = [NSNumber numberWithBool:self.changeIsDone];
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTableNotification object:nil];

}
-(void)setChangeIsDone:(BOOL)changeIsDone {
    _changeIsDone = changeIsDone;
    [self.checkButton setImage:[UIImage imageNamed:changeIsDone? @"Check.png" : @"Delete.png"] forState:UIControlStateNormal];
}
-(void)setGivingSticker:(Sticker *)givingSticker {
    _givingSticker = givingSticker;
    self.givingName.text = _givingSticker.name;
    self.givingIndex.text = [NSString stringWithFormat:@"%@",givingSticker.index];

}
-(void)setReceivingSticekr:(Sticker *)receivingSticekr {
    _receivingSticekr = receivingSticekr;
    self.receivingName.text = receivingSticekr.name;
    self.receivingIndex.text = [NSString stringWithFormat:@"%@",receivingSticekr.index];
}
@end
