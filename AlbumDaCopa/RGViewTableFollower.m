//
//  RGViewTableFollower.m
//  AlbumDaCopa
//
//  Created by Rafael Gonçalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "RGViewTableFollower.h"

@implementation RGViewTableFollower

-(id)initWithTableView:(UITableView *)table {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object) {
        NSValue *contentOffset = (NSValue *)object;
        NSLog(@"%@",contentOffset);
    }
}


@end
