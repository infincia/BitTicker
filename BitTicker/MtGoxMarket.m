//
//  MtGoxMarket.m
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import "MtGoxMarket.h"

#import "Trade.h"
#import "Ticker.h"
#define MTGOX_TICKER_URL @"https://mtgox.com/code/data/ticker.php"
#define MTGOX_TRADES_URL @"https://mtgox.com/code/data/getTrades.php"
#define MTGOX_MARKETDEPTH_URL @"https://mtgox.com/code/data/getDepth.php"
#define MTGOX_WALLET_URL @"https://mtgox.com/code/getFunds.php"


@interface MtGoxMarket (Private)
-(NSString*)makeURLStringWithSuffix:(NSString*)suffix;
@end

@implementation MtGoxMarket

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate {
    if (!(self = [super initWithDelegate:delegate])) return self;
    _tickerURL = MTGOX_TICKER_URL;
	_tradeURL = MTGOX_TRADES_URL;
	_depthURL = MTGOX_MARKETDEPTH_URL;
	_walletURL = MTGOX_WALLET_URL;
    return self;
}

-(void)fetchRecentTrades {
    MSLog(@"Fetching recent trades...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:self.tradeURL] callback:@selector(didFetchRecentTrades:)];
}

-(void)fetchTicker {
    MSLog(@"Fetching ticker...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:self.tickerURL] callback:@selector(didFetchTickerData:)];
}

-(void)fetchMarketDepth {
    MSLog(@"Fetching market depth...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:self.depthURL] callback:@selector(didFetchMarketDepth:)];
}

-(void)fetchWallet {
    MSLog(@"Fetching wallet...");
	NSString *username = sharedSettingManager.username;
	NSString *password = sharedSettingManager.password;
	if ([username isEqualToString:@"ChangeMe"] || username == nil) {
		return;
	}
	if ([password isEqualToString:@"ChangeMe"] || password == nil) {
		return;
	}
	NSDictionary *post = [NSDictionary dictionaryWithObjectsAndKeys:username,@"name",password,@"pass",nil];
	[self downloadJsonDataFromURL:[NSURL URLWithString:self.walletURL] withPostData:post callback:@selector(didFetchWallet:)];
}

-(void)didFetchRecentTrades:(NSArray*)tradeData {
    NSMutableArray *trades = [NSMutableArray array];
    
    for (NSDictionary *tradeDict in tradeData) {
        Trade *newTrade = [[Trade alloc] init];
        newTrade.amount = [tradeDict objectForKey:@"amount"];
        newTrade.price = [tradeDict objectForKey:@"price"];
        newTrade.tid = [[tradeDict objectForKey:@"tid"] intValue];
        
        newTrade.date = [NSDate dateWithTimeIntervalSince1970:[[tradeDict objectForKey:@"amount"] doubleValue]];
        
        [trades addObject:newTrade];
        [newTrade release];
    }
    MSLog(@"Got %i trades",trades.count);
    
    // Reverse the trades so 0 is the most recent
    NSMutableArray *orderedTrades = [NSMutableArray array];
    NSEnumerator *reverseEnumerator = [trades reverseObjectEnumerator];
    id object;
    
    while ((object = [reverseEnumerator nextObject])) {
        [orderedTrades addObject:object];
    }
    
    [_delegate bitcoinMarket:self didReceiveRecentTradesData:orderedTrades];
}

-(void)didFetchTickerData:(NSDictionary*)tickerData {
    NSDictionary *tickerDict = [tickerData objectForKey:@"ticker"];
    
    Ticker *ticker = [[Ticker alloc] init];
    ticker.buy = [tickerDict objectForKey:@"buy"];
    ticker.sell = [tickerDict objectForKey:@"sell"];
    ticker.high = [tickerDict objectForKey:@"high"];
    ticker.low = [tickerDict objectForKey:@"low"];
    ticker.last = [tickerDict objectForKey:@"last"];
    ticker.volume = [tickerDict objectForKey:@"vol"];
    
    [_delegate bitcoinMarket:self didReceiveTicker:ticker];
    [ticker release];
}

-(void)didFetchMarketDepth:(NSDictionary*)marketDepth {
    MSLog(@"Got %i asks and %i bids",[[marketDepth objectForKey:@"asks"] count],[[marketDepth objectForKey:@"bids"] count]);
}

-(void)didFetchWallet:(NSDictionary *)wallet {
	[_delegate bitcoinMarket:self didReceiveWallet:wallet];
}

@end
