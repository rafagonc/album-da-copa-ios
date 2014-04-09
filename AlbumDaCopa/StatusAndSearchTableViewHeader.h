//
//  StatusAndSearchTableViewHeader.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/3/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 768 : 320

@interface StatusAndSearchTableViewHeader : UIView <ADBannerViewDelegate> {
    UIActivityIndicatorView *activity;
}
@property (nonatomic,strong) ADBannerView *banner;
@property (nonatomic,strong) UISearchBar *bar;
@property (nonatomic,strong) UILabel *percentComplete;
@property (nonatomic,strong) UILabel *remainToCompleteLabel;

-(void)addViewsWithSearchBarDelegate:(UIViewController<UISearchBarDelegate> *)viewController;
@end
