//
//  TradeHillPanel.m
//  BitTicker
//
//  Created by steve on 6/13/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TradeHillPanel.h"


@implementation TradeHillPanel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTicker:) name:@"TradeHill-Ticker" object:nil];
 
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
