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

@end
