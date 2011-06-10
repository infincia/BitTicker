//
//  MenuController.h
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitcoinMarketDelegate.h"
@class StatusItemView;
@class Ticker;
@class BitcoinMarket;

@interface MenuController : NSObject <BitcoinMarketDelegate> {


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
	
	NSView *statsView;
	NSMenuItem *statsItem;

    NSView *walletView;
    NSMenuItem *walletItem;
		
	NSMenuItem *quitItem;
    NSMenuItem *aboutItem;
	NSMenuItem *settingsItem;
    NSMenuItem *refreshItem;
	NSMenuItem *preferenceItem;
	
	NSMenu *trayMenu;
	
	StatusItemView *statusItemView;
	NSStatusItem *_statusItem;
	NSNumberFormatter *currencyFormatter;
	
	NSNumber *_tickerValue;
    
}

-(void)createMenus;

@property (retain, nonatomic) NSNumber *tickerValue;

@end
