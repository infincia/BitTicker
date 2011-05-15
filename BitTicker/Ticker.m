//
//  Ticker.m
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import "Ticker.h"


@implementation Ticker
@synthesize high=_high;
@synthesize low=_low;
@synthesize volume=_volume;
@synthesize buy=_buy;
@synthesize sell=_sell;
@synthesize last=_last;

-(NSString*)description {
    return [NSString stringWithFormat:@"<Trade: last=%@, high=%@, low=%@, volume=%@>",_last, _high, _low, _volume];
}

@end
