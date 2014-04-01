//
//  StickerCell.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StickerCell.h"

@implementation StickerCell

#pragma mark - AWAKE
-(void)awakeFromNib {
    [super awakeFromNib];
    self.leftoversButton.delegate = self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - GETTERS AND SETTERS
-(void)setHasIt:(BOOL)hasIt {
    _hasIt = hasIt;
    if (hasIt) {
        self.sticker.onAlbum = @YES;
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"Check.png"] forState:UIControlStateNormal];
    } else {
        self.sticker.onAlbum = @NO;
        self.leftoversButton.text = @"+";
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
    }
    [[AppDelegate staticManagedObjectContext] save:nil];
}
-(void)setSticker:(Sticker *)sticker {
    _sticker = sticker;
    self.hasIt = sticker.onAlbum.boolValue;
    self.nameLabel.text = [self fixStickerString:sticker.name andSticker:sticker];
    self.indexLabel.text = [NSString stringWithFormat:@"%d",sticker.index.intValue];
    self.typeLabel.text = sticker.type;
    self.leftoversButton.text = [NSString stringWithFormat:sticker.leftovers.intValue? @"+%d" : @"+", sticker.leftovers.intValue];
}

#pragma mark - CHECK ACTION
- (IBAction)checkAction:(id)sender {
    self.hasIt = !self.hasIt;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangedStatsNotification object:nil];
}

#pragma mark - METHODS
-(NSString *)fixStickerString:(NSString *)s andSticker:(Sticker *)sticker {
    if ([s isEqualToString:@"Badge"]) {
        NSString *firstLetter = [[sticker.section substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSString *team = [sticker.section stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];
        return [NSString stringWithFormat:@"%@ %@", team, s];
        
    } else if ([s isEqualToString:@"Team"]) {
        NSString *firstLetter = [[sticker.section substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSString *team = [sticker.section stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];
        return [NSString stringWithFormat:@"%@ Squad", team];
    } else return s;
}

#pragma mark - DELEGATE
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@",string);
    self.leftoversButton.text = [NSString stringWithFormat:@"+%@",string];
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.hasIt) {
        [[[UIAlertView alloc] initWithTitle:@"Wait!" message:@"First, confirm that you have the sticker on the album, then you can have left overs" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        [textField resignFirstResponder];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger leftovers = [[self.leftoversButton.text stringByReplacingOccurrencesOfString:@"+" withString:@""] integerValue];
    self.sticker.leftovers = @(leftovers);
    [[AppDelegate staticManagedObjectContext] save:nil];
}
@end
