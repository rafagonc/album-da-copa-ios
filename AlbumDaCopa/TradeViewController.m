//
//  TradeViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeViewController.h"

@interface TradeViewController ()
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
@end

static NSString *const serviceType = @"session";

@implementation TradeViewController

#pragma mark - INIT
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"TradeViewController-iPad" : @"TradeViewController" bundle:nil];
    if (self) {
        isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    }
    return self;
}

#pragma mark - VIEW
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    isConnected = NO;
    
    [self setupTableView];
    [self setUpMultipeer];
    [self decorator];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self.advertiser start];
}
-(void)setUpMultipeer {
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:serviceType session:self.mySession];
    self.browserVC.delegate = self;

    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType discoveryInfo:nil session:self.mySession];
}
-(void)setupTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;

    
}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.tradeTableView.tableHeaderView.backgroundColor = flatBlue;
    self.followTable.backgroundColor = flatBlue;
    self.searchButton.backgroundColor = flatBlue;
}

#pragma mark - GENERAL METHODS
-(BOOL)getNeededStickers {
    NSMutableArray *indexesArray = [[NSMutableArray alloc] initWithCapacity: self.tradeData.count * 2];
    for (NSDictionary *dict in self.tradeData) {
        [indexesArray addObject:dict[@"give"]];
        [indexesArray addObject:dict[@"receive"]];
    }
    NSManagedObjectContext *context = [AppDelegate staticManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Sticker" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index IN %@", indexesArray]];
    NSError *error;
    self.neededStickers = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    return error == nil;
}

#pragma mark - BROWSER DELEGATE
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
   
}
-(void)sendData {
    NSError *error;
    NSLog(@"%@",[self.mySession connectedPeers]);
    if (![self.mySession sendData:[StickerController jsonFromAllStickers] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error]) {
        NSLog(@"%@",error);
    }
    
}

#pragma mark - ACTIONS
-(IBAction)procurarDispositivos:(id)sender {
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !isConnected? 1 : self.tradeData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (!isConnected && !isPad)? 138.0f : 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    TradeCell *cell = (TradeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        if (isConnected) cell = [[NSBundle mainBundle] loadNibNamed:isPad? @"TradeCell-iPad" : @"TradeCell" owner:self options:nil][0];
        else cell = [[NSBundle mainBundle] loadNibNamed:isPad? @"ExplanationCell-iPad" : @"ExplanationCell" owner:self options:nil][0];
    }
    if (!isConnected)  return cell;
    
    NSDictionary *tradeDict = self.tradeData[indexPath.row];
    cell.givingSticker =[self.neededStickers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.index == %d", [tradeDict[@"give"] integerValue]]][0];
    cell.receivingSticekr = [self.neededStickers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.index == %d", [tradeDict[@"receive"] integerValue]]][0];;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) return;
    self.followTable.frame = CGRectMake(self.followTable.frame.origin.x, self.followTable.frame.origin.y, self.followTable.frame.size.width, -scrollView.contentOffset.y);
}

#pragma mark - SESSION DELEGATE
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        if (!isPad) [self.browserVC dismissViewControllerAnimated:YES completion:nil];
        [self sendData];
    }
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    isConnected = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TradeController *trade = [[TradeController alloc] initWithJSONData:data];
        self.tradeData = [trade startComparingStickersToFindPossibleExchanges];
        if (![self getNeededStickers]) return;
        [self.tradeTableView reloadData];
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.3];
    });
    
}
-(void)reloadTable {
    [self.tradeTableView setNeedsDisplay];
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
