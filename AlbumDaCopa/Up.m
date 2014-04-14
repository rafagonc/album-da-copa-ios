//
//  Up.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/14/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "Up.h"

@implementation Up

- (id)initWithMasterTableView:(UITableView *)tableView {
    self = [[NSBundle mainBundle] loadNibNamed:@"Up" owner:self options:nil][0];
    if (self) {
        self.masterTableView = tableView;
        [self observeValueForKeyPath:@"contentOffset" ofObject:self.masterTableView change:nil context:nil];
        UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
        self.upButton.backgroundColor = flatBlue;
    }
    return self;
}

- (IBAction)upAction:(id)sender {
    [self.masterTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}




@end
