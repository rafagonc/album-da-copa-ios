//
//  Up.h
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/14/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Up : UIView

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (nonatomic,strong) UITableView *masterTableView;
- (id)initWithMasterTableView:(UITableView *)tableView;
@end
