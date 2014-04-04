//
//  StickerTableViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/1/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StickerTableViewController.h"

@interface StickerTableViewController () {
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignValueToViews) name:ChangedStatsNotification object:nil];
    
    if (self.shouldBeginIntroduction) [self setupIntroductionViews]; else [self setupNormalHeader];
    
    [self assignValueToViews];
    [self setupNavigationBar];
    [self decorator];


    


}

#pragma mark - LAYOUT SETUP
-(void)setupNavigationBar {
    doneOrTradeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 70, 26)];
    doneOrTradeButton.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(89/255.0) blue:(127/255.0) alpha:1];
    [doneOrTradeButton setTitle:self.shouldBeginIntroduction? @"Done" : @"Trade" forState:UIControlStateNormal];
    [doneOrTradeButton.layer setCornerRadius:10];
    [doneOrTradeButton addTarget:self action:@selector(introductionFinished:) forControlEvents:UIControlEventTouchUpInside];
    [doneOrTradeButton.layer setMasksToBounds:YES];
    doneOrTradeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    doneOrTradeButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self.navigationItem setTitleView:doneOrTradeButton];
}
-(void)setupIntroductionViews {
    IntroductionTableViewHeader *introView = [[IntroductionTableViewHeader alloc] init];
    [introView addTitleLabel:@"Check the stickers that you already have on the album. You can set leftovers too, in case you want to use the trade system" andSearchBarWithDelegate:self];
    introView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1];
    [self.tableView setTableHeaderView:introView];
}
-(void)setupNormalHeader {
    self.normalHeader = [[StatusAndSearchTableViewHeader alloc] init];
    [self.normalHeader addViewsWithSearchBarDelegate:self];
    [self.tableView setTableHeaderView:self.normalHeader];

}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    
    [[UINavigationBar appearance] setBarTintColor:flatBlue];
    [[UINavigationBar appearance] setBarTintColor:flatBlue];
    self.statusBarCover.backgroundColor = flatBlue;
    self.sliderHandlerView.backgroundColor = flatBlue;
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.clipsToBounds = YES;

}

#pragma mark - GENERAL METHODS


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL isFirstTime = [change[@"new"] boolValue];
    self.shouldBeginIntroduction = isFirstTime;
    if (!isFirstTime) {
        return;
    }
    [self performSelector:@selector(presentTutorial) withObject:nil afterDelay:1];
    self.stickers = [StickerController allStickers];
    [self.tableView reloadData];
    [self setupIntroductionViews];


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
    NSPredicate *indexPredicate = [NSPredicate predicateWithFormat:@"self.index.intValue == %d",searchBar.text.integerValue];

    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate,sectionPredicate, indexPredicate]];
    
    self.stickers = [[StickerController allStickers] filteredArrayUsingPredicate:compoundPredicate];
    [self.tableView reloadData];
}

#pragma mark - ACTIONS
-(void)introductionFinished:(id)sender {
    [self setupNormalHeader];
    [self assignValueToViews];
    [doneOrTradeButton setTitle:@"Trade" forState:UIControlStateNormal];

}
-(void)presentTutorial {
    TutorialViewController *tut = [[TutorialViewController alloc] init];
    [self presentViewController:tut animated:YES completion:nil];
}

#pragma mark - NOTIFICATIONS
-(void)assignValueToViews {
    NSArray *values = [StickerController statsForTheAlbum];
    self.normalHeader.percentComplete.text = [[NSString stringWithFormat:@"%.2f",[values[0] doubleValue]] stringByAppendingString:@"%"];
    self.normalHeader.remainToCompleteLabel.text = [NSString stringWithFormat:@"%d/640",[values[1] intValue]];
    
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
