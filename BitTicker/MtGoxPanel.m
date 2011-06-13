//
//  MtGoxPanel.m
//  BitTicker
//
//  Created by steve on 6/13/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MtGoxPanel.h"


@implementation MtGoxPanel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTicker:) name:@"MtGox-Ticker" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWallet:) name:@"MtGox-Wallet" object:nil];

    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
