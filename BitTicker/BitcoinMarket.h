//
//  BitcoinMarket.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/27/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BitcoinMarketDelegate.h"
#import "RequestHandlerDelegate.h"
#import "SharedSettings.h"

enum kBitcoinMarkets {
    eMarketMtGox = 0,
    // Used for market enumeration. Keep this as the last value.
    eNumberOfMarkets = 1 
};

@class RequestHandler;

@interface BitcoinMarket : NSObject <RequestHandlerDelegate> {
    RequestHandler *requestHandler;
    id<BitcoinMarketDelegate> _delegate;
    
    NSMutableDictionary *_selectorMap;
	SharedSettings *sharedSettingManager;
	
	NSString *_tradeURL;
	NSString *_tickerURL;
	NSString *_depthURL;
	NSString *_walletURL;
}
-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate;

-(void)downloadJsonDataFromURL:(NSURL*)url callback:(SEL)callback;
-(void)downloadJsonDataFromURL:(NSURL*)url withPostData:(NSDictionary*)postData callback:(SEL)callback;

// Overwrite these in each market
-(NSURL*)getTickerDataURL;
-(NSURL*)getRecentTradeURL;

-(void)fetchRecentTrades;
-(void)fetchTicker;
-(void)fetchMarketDepth;
-(void)fetchWallet;

@property (nonatomic, assign) id<BitcoinMarketDelegate> delegate;

@property (readonly,nonatomic,retain) NSString *tradeURL;
@property (readonly,nonatomic,retain) NSString *tickerURL;
@property (readonly,nonatomic,retain) NSString *depthURL;
@property (readonly,nonatomic,retain) NSString *walletURL;

@end
