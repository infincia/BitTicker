//
//  Ticker.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BitcoinMarket;


@interface Ticker : NSObject {
    NSNumber *_high;
    NSNumber *_low;
    NSNumber *_volume;
    NSNumber *_buy;
    NSNumber *_sell;
    NSNumber *_last;
	BitcoinMarket *_market;
}
@property (retain) BitcoinMarket *market;
@property (nonatomic, retain)  NSNumber *high;
@property (nonatomic, retain)  NSNumber *low;
@property (nonatomic, retain)  NSNumber *volume;
@property (nonatomic, retain)  NSNumber *buy;
@property (nonatomic, retain)  NSNumber *sell;
@property (nonatomic, retain)  NSNumber *last;
@end
