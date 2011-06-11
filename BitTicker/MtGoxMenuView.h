//
//  MtGoxMenuView.h
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomMenuView.h"

@interface MtGoxMenuView : CustomMenuView {

	NSTextField *highValue;
	NSTextField *lowValue;
	NSTextField *volValue;
	NSTextField *buyValue;
	NSTextField *sellValue;
	NSTextField *lastValue;
	
	NSTextField *BTCValue;
	NSTextField *BTCxUSDValue;
	NSTextField *USDValue;
    NSTextField *walletUSDValue;	
    
}

@property (retain) NSString *high;
@property (retain) NSString *low;
@property (retain) NSString *vol;
@property (retain) NSString *buy;
@property (retain) NSString *sell;
@property (retain) NSString *last;
	
@property (retain) NSString *btc;
@property (retain) NSString *btcusd;
@property (retain) NSString *usd;
@property (retain) NSString *wallet;

@end
