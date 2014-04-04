//
//  IntroductionTableViewHeader.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/3/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "IntroductionTableViewHeader.h"

@implementation IntroductionTableViewHeader

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 110)];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1]];
    }
    return self;
}
-(void)addTitleLabel:(NSString *)text andSearchBarWithDelegate:(id<UISearchBarDelegate>)viewController {
    UISearchBar *searchBar = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:kNilOptions][0];
    searchBar.placeholder = @"Search for Teams, Players or Numbers";
    searchBar.delegate = viewController;
    searchBar.backgroundColor = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    [self addSubview:searchBar];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, searchBar.frame.origin.y + searchBar.frame.size.height , 280, 60)];;
    self.textLabel.text = text;
    self.textLabel.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1];
    self.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
    
    
}




@end
