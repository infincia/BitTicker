//
//  BtcGuild.h
//  BitTicker
//
//  Created by colin on 6/9/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BitcoinMarket.h"
#import "Miner.h"

@interface BtcGuild : BitcoinMarket {
    
}

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate;

@end
