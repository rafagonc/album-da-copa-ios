//
//  IntroductionTableViewHeader.h
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/3/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroductionTableViewHeader : UIView
@property (nonatomic,strong) UILabel *textLabel;
-(void)addTitleLabel:(NSString *)text andSearchBarWithDelegate:(id<UISearchBarDelegate>)viewController;
@end
