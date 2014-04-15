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
    self = [[NSBundle mainBundle] loadNibNamed:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? @"Up-iPad" : @"Up" owner:self options:nil][0];
    if (self) {
        self.frame = CGRectMake(0, 20 ,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 768 : 320, 50);
        self.masterTableView = tableView;
        [self.masterTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
        self.upButton.backgroundColor = flatBlue;
    }
    return self;
}

- (IBAction)upAction:(id)sender {
    [self.masterTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!change) return;
    double y = [change[@"new"] CGPointValue].y;
    [self animateUpViewWithAlpha:y > 200.0f];
}
-(void)animateUpViewWithAlpha:(BOOL)alpha {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = alpha;
    }];
}

@end
