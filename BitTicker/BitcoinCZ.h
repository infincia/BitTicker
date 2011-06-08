//
//  BitcoinCZ.h
//  BitTicker
//
//  Created by steve on 6/8/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BitcoinMarket.h"
#import "Miner.h"

@interface BitcoinCZ : BitcoinMarket {
    
}

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate;

@end
