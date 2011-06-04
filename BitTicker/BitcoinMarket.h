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

@class RequestHandler;

@interface BitcoinMarket : NSObject <RequestHandlerDelegate> {
    RequestHandler *requestHandler;
    id<BitcoinMarketDelegate> _delegate;
    
    NSMutableDictionary *_selectorMap;
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

@end
