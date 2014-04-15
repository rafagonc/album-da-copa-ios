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
    self = [super initWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"StickerTableViewController-iPad" : @"StickerTableViewController" bundle:nil];
    if (self) {
        isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.upView = [[Up alloc] initWithMasterTableView:self.tableView];
    [self.view addSubview:self.upView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignValueToViews) name:ChangedStatsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:ReloadTableNotification object:nil];
    
    
    [self setupNormalHeader];
    [self assignValueToViews];
    [self decorator];

}

#pragma mark LAYOUT
-(void)setupNormalHeader {
    self.normalHeader = [[StatusAndSearchTableViewHeader alloc] init];
    [self.normalHeader addViewsWithSearchBarDelegate:self];
    [self.tableView setTableHeaderView:self.normalHeader];

}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.statusBarCover.backgroundColor = flatBlue;
    self.sliderHandlerView.backgroundColor = flatBlue;
    self.view.backgroundColor = flatBlue;
}


#pragma mark - GENERAL METHODS
-(void)showAd {
    [AdColony playVideoAdForZone:ADCOLONY__ZONE withDelegate:nil];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL isFirstTime = [change[@"new"] boolValue];
    self.shouldBeginIntroduction = isFirstTime;
    if (isFirstTime) {
        [self performSelector:@selector(presentTutorial) withObject:nil afterDelay:1];
    }
    self.stickers = [StickerController allStickers];
    [self.tableView reloadData];


}

#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stickers.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Sticker";
    StickerCell *cell = (StickerCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:isPad ? @"StickerCell-iPad" : @"StickerCell" owner:self options:nil][0];
        cell.leftoversTextField.layer.masksToBounds = YES;
        cell.leftoversTextField.layer.cornerRadius = 19;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"Reused");
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
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[self isNumber:searchBar.text]?@[indexPredicate] : @[namePredicate,sectionPredicate]];
    
    self.stickers = [[StickerController allStickers] filteredArrayUsingPredicate:compoundPredicate];
    [self.tableView reloadData];
}
-(BOOL)isNumber:(NSString *)text {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [text rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

#pragma mark - ACTIONS
-(void)buttonFinishedAction:(id)sender {
    if (self.shouldBeginIntroduction) {
        [self setupNormalHeader];
        [self assignValueToViews];
        [doneOrTradeButton setTitle:@"Trade" forState:UIControlStateNormal];
        self.shouldBeginIntroduction = NO;
    } else {
        
        
    }
    

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
-(void)reloadTable {
    self.stickers = [StickerController allStickers];
    [self.tableView reloadData];
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
