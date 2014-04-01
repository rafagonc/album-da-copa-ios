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
        self.stickers = [StickerController allStickers];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self decorator];
    [self assignValueToViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignValueToViews) name:ChangedStatsNotification object:nil];

}
-(void)decorator {
    self.numberOfStickersToBeCompletedLabel.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.percentCompletedLabel.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.percentCompletedLabel.layer.masksToBounds = YES;
    self.percentCompletedLabel.layer.cornerRadius = 9;
    self.numberOfStickersToBeCompletedLabel.layer.masksToBounds = YES;
    self.numberOfStickersToBeCompletedLabel.layer.cornerRadius = 9;
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(66/255.0) green:(114/255.0) blue:(155/255.0) alpha:1]];
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:(66/255.0) green:(114/255.0) blue:(155/255.0) alpha:1];
    self.statusBarCover.backgroundColor = [UIColor colorWithRed:(66/255.0) green:(114/255.0) blue:(155/255.0) alpha:1];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    self.title = @"My Album";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor whiteColor]};
}
-(void)assignValueToViews {
    NSArray *values = [StickerController statsForTheAlbum];
    self.percentCompletedLabel.text = [[NSString stringWithFormat:@"%.2f",[values[0] doubleValue]] stringByAppendingString:@"%"];
    self.numberOfStickersToBeCompletedLabel.text = [NSString stringWithFormat:@"%d/640",[values[1] intValue]];
}


#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stickers.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Sticker";
    StickerCell *cell = (StickerCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StickerCell" owner:self options:nil][0];
        cell.leftoversButton.layer.masksToBounds = YES;
        cell.leftoversButton.layer.cornerRadius = 19;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Sticker *sticker = self.stickers[indexPath.row];
    cell.sticker = sticker;
    
    
    
    return cell;
}
#pragma mark - SEARCH BAR DELEGATE
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.stickers = [StickerController allStickers];
        [self.tableView reloadData];
        return;
    }
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"self.name contains[cd]%@",searchBar.text];
    NSPredicate *sectionPredicate = [NSPredicate predicateWithFormat:@"self.section contains[cd]%@",searchBar.text];
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate,sectionPredicate]];
    
    self.stickers = [[StickerController allStickers] filteredArrayUsingPredicate:compoundPredicate];
    [self.tableView reloadData];
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
