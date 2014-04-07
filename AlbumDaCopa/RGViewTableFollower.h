//
//  RGViewTableFollower.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGViewTableFollower : UIView
@property (nonatomic,strong) UITableView *tableView;
-(id)initWithTableView:(UITableView *)table ;
@end
