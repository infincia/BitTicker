//
//  TradeHillMarket.m
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TradeHillMarket.h"

#import "Trade.h"
#import "Ticker.h"
#import "Wallet.h"

// TODO: they have URLs for multiple currencies...
#define TRADEHILL_TICKER_URL @""
#define TRADEHILL_TRADES_URL @"https://www.tradehill.com/API/USD/Trades"
#define TRADEHILL_MARKETDEPTH_URL @"https://www.tradehill.com/API/USD/Orderbook"
#define TRADEHILL_WALLET_URL @""

@implementation TradeHillMarket

-(id)init {
    if (!(self = [super initWithDelegate:self])) return self;
    _tickerURL = TRADEHILL_TICKER_URL;
	_tradeURL = TRADEHILL_TRADES_URL;
	_depthURL = TRADEHILL_MARKETDEPTH_URL;
	_walletURL = TRADEHILL_WALLET_URL;
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
	NSString *username = [sharedSettingManager usernameForMarket:eMarketTradeHill];
	NSString *password = [sharedSettingManager passwordForMarket:eMarketTradeHill];
	if ([username isEqualToString:@""] || username == nil) {
		return;
	}
	if ([password isEqualToString:@""] || password == nil) {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeHill-Trades" object:tradeData];
    
}

-(void)didFetchTickerData:(NSDictionary*)tickerData {
    NSDictionary *tickerDict = [tickerData objectForKey:@"ticker"];
    
    Ticker *ticker = [[Ticker alloc] init];
	// Dont know if these are correct yet
    ticker.buy = [tickerDict objectForKey:@"buy"];
    ticker.sell = [tickerDict objectForKey:@"sell"];
    ticker.high = [tickerDict objectForKey:@"high"];
    ticker.low = [tickerDict objectForKey:@"low"];
    ticker.last = [tickerDict objectForKey:@"last"];
    ticker.volume = [tickerDict objectForKey:@"vol"];
    ticker.market = self;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TradeHill-Ticker" object:ticker];
	
    [ticker release];
}

-(void)didFetchMarketDepth:(NSDictionary*)marketDepth {
    MSLog(@"Got %i asks and %i bids",[[marketDepth objectForKey:@"asks"] count],[[marketDepth objectForKey:@"bids"] count]);
}

-(void)didFetchWallet:(NSDictionary *)dictwallet {
	Wallet *newwallet = [[Wallet alloc] init];
	
	// these might need to be changed once their API is available
	newwallet.btc = [dictwallet objectForKey:@"btcs"];
	newwallet.usd = [dictwallet objectForKey:@"usds"];
	newwallet.market = self;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TradeHill-Wallet" object:newwallet];
}


- (void)dealloc
{
    [super dealloc];
}

@end
