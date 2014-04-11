//
//  TradeViewController.m
//  AlbumDaCopa
//
//  Created by Rafael Gonzalves on 4/7/14.
//  Copyright (c) 2014 Rafael Gonzalves. All rights reserved.
//

#import "TradeViewController.h"
#import "SessionDelegateContainer.h"

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
    [self setupTableView];
    [self setUpMultipeer];
    [self decorator];
    
}
-(void)setUpMultipeer {
    //  Setup peer ID
    SessionDelegateContainer *delegateContainer = [[SessionDelegateContainer alloc] init];
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:serviceType session:self.mySession];
    self.browserVC.delegate = self;
    [self presentViewController:self.browserVC animated:YES completion:nil];

    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}
-(void)setupTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;
}
-(void)decorator {
    UIColor *flatBlue = [UIColor colorWithRed:(56/255.0) green:(104/255.0) blue:(145/255.0) alpha:1];
    self.tradeTableView.tableHeaderView.backgroundColor = flatBlue;
    self.followTable.backgroundColor = flatBlue;
}

#pragma mark - BROWSER
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(sendData) withObject:nil afterDelay:0.2];
   
}
-(void)sendData {
    NSError *error;
    NSLog(@"%@",[self.mySession connectedPeers]);
    if (![self.mySession sendData:[StickerController jsonFromAllStickers] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error]) {
        NSLog(@"%@",error);
    }
    
}


#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DeviceCell" owner:self options:nil][0];
    }
    
    CBPeripheral *peri = self.devices[indexPath.row];
    cell.deviceName.text = peri.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peri = self.devices[indexPath.row];


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) return;
    self.followTable.frame = CGRectMake(self.followTable.frame.origin.x, self.followTable.frame.origin.y, self.followTable.frame.size.width, -scrollView.contentOffset.y);
}




-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {

    
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    TradeController *trade = [[TradeController alloc] initWithJSONData:data];
    NSMutableArray *stickers = [trade startComparingStickersToFindPossibleExchanges];
    NSLog(@"%@",stickers);
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
