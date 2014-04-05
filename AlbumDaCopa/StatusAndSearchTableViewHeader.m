//
//  StatusAndSearchTableViewHeader.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/3/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "StatusAndSearchTableViewHeader.h"

@implementation StatusAndSearchTableViewHeader

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 150)];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1]];
    }
    return self;
}
-(void)addViewsWithSearchBarDelegate:(UIViewController<UISearchBarDelegate> *)viewController {
    UISearchBar *searchBar = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil][0];
    searchBar.placeholder = @"Search for Teams, Players or Numbers";
    searchBar.delegate = viewController;
    searchBar.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    [self addSubview:searchBar];
    
    UIView *statusContainer = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.frame.size.height, 320, 50)];
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
    
    self.banner = [[NSBundle mainBundle] loadNibNamed:@"ADBanner" owner:self options:nil][0];
    [self.banner setFrame:CGRectMake(0, statusContainer.frame.size.height + searchBar.frame.size.height + 6, 320, 50)];
    self.banner.delegate =self;
    [self addSubview:self.banner];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(self.banner.frame.size.width/2, self.banner.frame.origin.y + self.banner.frame.size.height/2);
    activity.hidesWhenStopped = YES;
    [self addSubview:activity];
    [activity startAnimating];
    
  
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
