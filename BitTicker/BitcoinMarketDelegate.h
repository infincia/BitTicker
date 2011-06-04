//
//  BitcoinMarketDataSource.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/27/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BitcoinMarket;
@class Ticker;

@protocol BitcoinMarketDelegate <NSObject>

@required

// A request failed for some reason, for example the API being down
-(void)bitcoinMarket:(BitcoinMarket*)market requestFailedWithError:(NSError*)error;

// Request wasn't formatted as expected
-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveInvalidResponse:(NSData*)data;

@optional

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveTicker:(Ticker*)ticker;
-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveRecentTradesData:(NSArray*)trades;
-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveWallet:(NSDictionary*)wallet;
@end
