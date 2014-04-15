//
//  StatusAndSearchTableViewHeader.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/3/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StatusAndSearchTableViewHeader.h"
@implementation StatusAndSearchTableViewHeader
@synthesize segControl;

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    if (self) {
        NSLog(@"%d",SCREEN_WIDTH);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assignValuesToSegControl:) name:AssingValuesToSegControl object:nil];
    }
    return self;
}
-(void)addViewsWithSearchBarDelegate:(UIViewController<UISearchBarDelegate> *)viewController {
    UISearchBar *searchBar = [[NSBundle mainBundle] loadNibNamed:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? @"SearchBar-iPad" : @"SearchBar" owner:self options:nil][0];
    searchBar.placeholder = @"Procure por Número, Time, ou Jogador";
    searchBar.delegate = viewController;
    searchBar.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    [self addSubview:searchBar];
    
    UIView *statusContainer = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.frame.size.height, SCREEN_WIDTH, 50)];
    [statusContainer setBackgroundColor:[UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1]];
    [self addSubview:statusContainer];
    
    
    self.percentComplete = [[UILabel alloc] initWithFrame:CGRectMake(30, 10 , 120, 35)];;
    self.percentComplete.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(89/255.0) blue:(127/255.0) alpha:1];
    self.percentComplete.font = [UIFont boldSystemFontOfSize:14.0f];
    self.percentComplete.textColor = [UIColor whiteColor];
    self.percentComplete.layer.masksToBounds = YES;
    self.percentComplete.layer.cornerRadius = 10;
    self.percentComplete.textAlignment = NSTextAlignmentCenter;
    [statusContainer addSubview:self.percentComplete];
    
    
    self.remainToCompleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10 , 120, 35)];;
    self.remainToCompleteLabel.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(89/255.0) blue:(127/255.0) alpha:1];
    self.remainToCompleteLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.remainToCompleteLabel.layer.masksToBounds = YES;
    self.remainToCompleteLabel.layer.cornerRadius = 10;
    self.remainToCompleteLabel.textColor = [UIColor whiteColor];
    self.remainToCompleteLabel.textAlignment = NSTextAlignmentCenter;
    [statusContainer addSubview:self.remainToCompleteLabel];
    
    segControl = [[SDSegmentedControl alloc] initWithItems:@[@"Todas", [NSString stringWithFormat:@"Repetidas(%lu)", (unsigned long)[StickerController findLeftoversAvaliable].count], [NSString stringWithFormat:@"Faltam(%lu)", (unsigned long)[StickerController toGet].count]]];
    [segControl setFrame:CGRectMake(0, statusContainer.frame.origin.y + statusContainer.frame.size.height, SCREEN_WIDTH, 40)];
    [segControl setBackgroundColor:[UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1]];
    [segControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f]} forState:UIControlStateNormal];
    [segControl addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segControl];
    
    
    
    self.banner = [[NSBundle mainBundle] loadNibNamed:@"ADBanner" owner:self options:nil][0];
    [self.banner setFrame:CGRectMake(0, segControl.frame.origin.y + segControl.frame.size.height, SCREEN_WIDTH, 50)];
    self.banner.delegate =self;
    [self addSubview:self.banner];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(self.banner.frame.size.width/2, self.banner.frame.origin.y + self.banner.frame.size.height/2);
    activity.hidesWhenStopped = YES;
    [self addSubview:activity];
    [activity startAnimating];
    
  
}
-(void)changeTableView:(SDSegmentedControl *)sender {
    StickerTableViewController *stickerTable = (StickerTableViewController *)[[[self nextResponder] nextResponder] nextResponder];
    if (sender.selectedSegmentIndex == 0) {
        stickerTable.stickers = [StickerController allStickers];
    } else if (sender.selectedSegmentIndex == 1) {
        stickerTable.stickers = [StickerController findLeftoversAvaliable];
    } else {
        stickerTable.stickers = [StickerController toGet];
    }
    [stickerTable.tableView reloadData];
}
-(void)assignValuesToSegControl:(NSNotification *)not {
    NSString *s = (NSString *)not.object;
    if ([s isEqualToString:@"leftovers"]) {
        [segControl setTitle:[NSString stringWithFormat:@"Repetidas(%lu)", (unsigned long)[StickerController findLeftoversAvaliable].count] forSegmentAtIndex:1];
    } else {
        [segControl setTitle:[NSString stringWithFormat:@"Faltam(%lu)", (unsigned long)[StickerController toGet].count] forSegmentAtIndex:2];

    }
}

#pragma mark - BANNER DELEGATE
-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
    [activity startAnimating];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [activity stopAnimating];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [activity stopAnimating];
}

@end
