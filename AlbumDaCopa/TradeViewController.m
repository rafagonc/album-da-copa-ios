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
    
    self.mAction = Trade;
    
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
    [[UINavigationBar appearance] setBarTintColor:flatBlue];
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
    self.mAction = Trade;
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
   
}
-(void)sendData {
    NSError *error;
    if (![self.mySession sendData:[StickerController jsonFromAllStickers:self.mAction] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error]) NSLog(@"%@",error);
}

#pragma mark - ACTIONS
-(IBAction)procurarDispositivos:(id)sender {
    if (isConnected) {
        [UIAlertView showWithTitle:@"Alerta" message:[NSString stringWithFormat:@"Deseja desconectar do respectivo dispositivo: %@ ?", self.mySession.connectedPeers.count? [self.mySession.connectedPeers[0] displayName] : @""] cancelButtonTitle:@"Não" otherButtonTitles:@[@"Sim"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    isConnected = NO;
                    [self.mySession disconnect];
                    [self.tradeData removeAllObjects];
                    [self.searchButton setTitle:@"Procurar Dispositivos" forState:UIControlStateNormal];
                    [self.tradeTableView reloadData];
                });
            }
            return;
        }];
        return;
    }
    
    [self presentViewController:self.browserVC animated:YES completion:nil];
}
-(IBAction)plusAction:(UIButton *)sender {
    [UIActionSheet showInView:self.view withTitle:@"Opções. Para sair clique no resto da tela." cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@[ @"Deletar Álbum",@"Informações do Aplicativo"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [UIAlertView showWithTitle:@"Informações" message:@"Esse aplicativo foi criado por Rafael Gonçalves" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
            
            
        } else if (buttonIndex == 0) {
            [UIAlertView showWithTitle:@"Tem Certeza?" message:@"Ao confirmar esse alerta, você perderá todas as informações e figurinhas do seu álbum." cancelButtonTitle:@"NÃO!!" otherButtonTitles:@[@"Ok"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex2) {
                if (buttonIndex2 == 1) {
                    [StickerController deleteAllAlbum];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CellNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangedStatsNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:AssingValuesToSegControl object:@"toGet" userInfo:nil];
                }
            }];
            
            
        }
        
    }];
}

#pragma mark - TABLE VIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !isConnected? 1 : self.tradeData.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isConnected && !isPad) return 257.0f; else if (isPad && !isConnected) return 245.0f; else return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@ - %ld", isConnected? @"con" : @"not con", (long)indexPath.row]];
    if (!cell) {
        if (isConnected) {
            if (indexPath.row == self.tradeData.count) cell = [[NSBundle mainBundle] loadNibNamed:isPad? @"ExplanationCell2-iPad" : @"ExplanationCell2" owner:self options:nil][0];
            else cell = [[NSBundle mainBundle] loadNibNamed:isPad? @"TradeCell-iPad" : @"TradeCell" owner:self options:nil][0];
        }
        else cell = [[NSBundle mainBundle] loadNibNamed:isPad? @"ExplanationCell-iPad" : @"ExplanationCell" owner:self options:nil][0];
    }
    if (!isConnected || indexPath.row == self.tradeData.count)  return cell;
    
    NSDictionary *tradeDict = self.tradeData[indexPath.row];
    TradeCell *tradeCell = (TradeCell *)cell;
    tradeCell.givingSticker =[self.neededStickers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.index == %d", [tradeDict[@"give"] integerValue]]][0];
    tradeCell.receivingSticekr = [self.neededStickers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.index == %d", [tradeDict[@"receive"] integerValue]]][0];;
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isConnected = YES;
        [self.searchButton setTitle:peerID.displayName forState:UIControlStateNormal];
        [self didReceivedStickersFromOtherDevice:data];
            });
    
    
}
-(void)didReceivedStickersFromOtherDevice:(NSData *)jsonData {
    NSError *error;
    NSArray *dict  = [NSJSONSerialization JSONObjectWithData:[jsonData gunzippedData] options:NSJSONReadingAllowFragments error:&error];
    if (error || !dict.count) {
        return;
    }
        TradeController *trade = [[TradeController alloc] initWithJSONData:dict];
        self.tradeData = [trade startComparingStickersToFindPossibleExchanges];
        if (!self.tradeData.count) {
            [[[UIAlertView alloc] initWithTitle:@"Não existem trocas disponíveis." message:@"Verifique se todas suas figurinhas repetidas estão configuradas corretamente." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        if (![self getNeededStickers]) return;
        [self.tradeTableView reloadData];

 
}

#pragma mark - DEALLOC
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
