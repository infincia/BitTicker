//
//  MenuController.h
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedSettings.h"
@class StatusItemView;
@class Ticker;
@class BitcoinMarket;

@interface MenuController : NSObject {
	SharedSettings *sharedSettingManager;
	NSMenu *trayMenu;
	NSMutableDictionary *_viewDict;
	StatusItemView *statusItemView;
	NSStatusItem *_statusItem;
	
	NSNumberFormatter *currencyFormatter;
	
	NSNumber *_tickerValue;
	
	NSMenuItem *quitItem;
    NSMenuItem *aboutItem;
	NSMenuItem *settingsItem;
	NSMenuItem *mainWindowItem;
    NSMenuItem *refreshItem;
	NSMenuItem *preferenceItem;
	
	NSInteger _currentMenuStop;
    
}

-(void)createMenuForMarket:(BitcoinMarket*)market;

-(void)addSelectorItems;

@property (retain, nonatomic) NSNumber *tickerValue;
@property () NSInteger currentMenuStop;
@property (retain) NSMutableDictionary *viewDict;
@end
