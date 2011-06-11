//
//  TradeHillMarket.h
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BitcoinMarket.h"

@interface TradeHillMarket : BitcoinMarket {
    
}

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate;

@end
