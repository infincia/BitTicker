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

@interface MtGoxMarket (Private)
-(NSString*)makeURLStringWithSuffix:(NSString*)suffix;
@end

@implementation MtGoxMarket


-(void)fetchRecentTrades {
    MSLog(@"Fetching recent trades...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:MTGOX_TRADES_URL] callback:@selector(didFetchRecentTrades:)];
}

-(void)fetchTicker {
    MSLog(@"Fetching ticker...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:MTGOX_TICKER_URL] callback:@selector(didFetchTickerData:)];
}

-(void)fetchMarketDepth {
    MSLog(@"Fetching market depth...");
    [self downloadJsonDataFromURL:[NSURL URLWithString:MTGOX_MARKETDEPTH_URL] callback:@selector(didFetchMarketDepth:)];
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

@end
