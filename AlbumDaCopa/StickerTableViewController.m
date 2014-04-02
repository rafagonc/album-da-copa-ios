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
-(void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraAction:)];
    [cameraItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:cameraItem];
    
    UIBarButtonItem *externalItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(externalAction:)];
    [externalItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:externalItem];
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
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.numberOfStickersToBeCompletedLabel.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(89/255.0) blue:(127/255.0) alpha:1];
    self.percentCompletedLabel.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(89/255.0) blue:(127/255.0) alpha:1];;
    self.percentCompletedLabel.layer.masksToBounds = YES;
    self.percentCompletedLabel.layer.cornerRadius = 9;
    self.numberOfStickersToBeCompletedLabel.layer.masksToBounds = YES;
    self.numberOfStickersToBeCompletedLabel.layer.cornerRadius = 9;
    
    [[UINavigationBar appearance] setBarTintColor:flatBlue];
    [[UINavigationBar appearance] setBarTintColor:flatBlue];
    self.tableView.tableHeaderView.backgroundColor = flatBlue;
    self.statusBarCover.backgroundColor = flatBlue;
    self.sliderHandlerView.backgroundColor = flatBlue;
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.title = @"2014 World Cup Album";
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) return;
    self.sliderHandlerView.frame = CGRectMake(self.sliderHandlerView.frame.origin.x, self.sliderHandlerView.frame.origin.y, self.sliderHandlerView.frame.size.width, -scrollView.contentOffset.y);
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

#pragma mark - ACTIONS
-(void)cameraAction:(UIBarButtonItem *)sender {
    CameraViewController *cam = [[CameraViewController alloc] init];
    [self presentViewController:cam animated:YES completion:nil];
}
-(void)externalAction:(UIBarButtonItem *)sender {
    
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
