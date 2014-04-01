//
//  StickerTableViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StickerTableViewController.h"

@interface StickerTableViewController ()

@end

@implementation StickerTableViewController


#pragma mark - INIT
-(id)init {
    self = [super initWithNibName:@"StickerTableViewController" bundle:nil];
    if (self) {
        self.stickers = [Sticker allStickers];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stickers.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.stickers allValues][section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.stickers allKeys][section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Sticker";
    StickerCell *cell = (StickerCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StickerCell" owner:self options:nil][0];
        cell.leftoversButton.layer.masksToBounds = YES;
        cell.leftoversButton.layer.cornerRadius = 19;
    }
    
    Sticker *sticker = [self.stickers allValues][indexPath.section][indexPath.row];
    cell.nameLabel.text = sticker.name;
    cell.indexLabel.text = [NSString stringWithFormat:@"%d",sticker.index.intValue];
    
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}



#pragma mark - DEALLOC
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
