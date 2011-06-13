//
//  MtGoxMarket.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitcoinMarketDelegate.h"
#import "BitcoinMarket.h"
 
@interface MtGoxMarket : BitcoinMarket <BitcoinMarketDelegate> {

}

-(id)init;

@end
