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
    self.leftoversTextField.delegate = self;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
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
        self.sticker.dateAdded = [NSDate date];
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"Check.png"] forState:UIControlStateNormal];
    } else {
        self.sticker.onAlbum = @NO;
        self.sticker.dateAdded = nil;
        self.leftoversTextField.text = @"+";
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
    self.leftoversTextField.text = [NSString stringWithFormat:sticker.leftovers.intValue? @"+%d" : @"+", sticker.leftovers.intValue];
    self.countryImage.image = [UIImage imageNamed:sticker.countryImageName];
    self.stickerHasChanges = NO;
}
-(void)setStickerHasChanges:(BOOL)stickerHasChanges {
    if (stickerHasChanges) {
        [[AppDelegate staticManagedObjectContext] save:nil];
    }
    _stickerHasChanges = NO;
}

#pragma mark - CHECK ACTION
- (IBAction)checkAction:(id)sender {
    self.hasIt = !self.hasIt;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangedStatsNotification object:nil];
    self.stickerHasChanges = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:AssingValuesToSegControl object:@"toGet" userInfo:nil];
}

#pragma mark - METHODS
-(NSString *)fixStickerString:(NSString *)s andSticker:(Sticker *)sticker {
    if ([s isEqualToString:@"Badge"]) {
        NSString *firstLetter = [[sticker.section substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSString *team = [sticker.section stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];
        return [NSString stringWithFormat:@"%@ - Símbolo", team];
        
    } else if ([s isEqualToString:@"Team"]) {
        NSString *firstLetter = [[sticker.section substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSString *team = [sticker.section stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];
        return [NSString stringWithFormat:@"%@ - Time", team];
    } else return s;
}
-(BOOL)isNumber:(NSString *)text {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [text rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

#pragma mark - DELEGATE
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self isNumber:string]) {
        [[[UIAlertView alloc] initWithTitle:@"Insire Somente Números" message:@"Coloque nesse campo as figurinhas que você tem de sobra caso queria usar o sistema de troca." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return  textField.text.length < 3 /*clear*/ || [string isEqualToString:@""]; //delete;;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.hasIt) {
        [[[UIAlertView alloc] initWithTitle:@"Calma ai, Garotão!" message:@"Primeiro coloque que a figurinha está no album, depois adicione as repetidas!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        [textField resignFirstResponder];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) textField.text = @"+";
    
    NSInteger leftovers = [[self.leftoversTextField.text stringByReplacingOccurrencesOfString:@"+" withString:@""] integerValue];
    self.sticker.leftovers = @(leftovers);
    self.stickerHasChanges = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:AssingValuesToSegControl object:@"leftovers" userInfo:nil];
}
@end
