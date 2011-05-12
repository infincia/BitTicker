//  Created by steve on 5/2/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ticker.h"
#import "StatusItemView.h"

@interface BitTickerAppDelegate : NSObject <NSApplicationDelegate> {
    NSString *tickerValue;
	Ticker *_ticker;
	NSThread *updateThread;
	NSThread *tickerThread;
	int debugging;
	NSMutableArray *stats;
    NSMutableArray *highArray;
    NSMutableArray *lowArray;
	StatusItemView *statusItemView;
	NSStatusItem *_statusItem;

	//fields for each stat
	NSTextField *highValue;
	NSTextField *lowValue;
	NSTextField *volValue;
	NSTextField *buyValue;
	NSTextField *sellValue;
	NSTextField *lastValue;
    
	NSString *high;
    NSString *low;
    NSString *vol;
    NSString *buy;
    NSString *sell;
    NSString *last;

	NSView *statsView;
	NSMenuItem *statsItem;
	
	// below the line
	NSMenuItem *quitItem;
    NSMenuItem *aboutItem;
	NSMenuItem *preferenceItem;
	
	NSMenu *trayMenu;
}

- (void) startTickerThread;
- (void) startTicker;
- (void) updateTickerData;
- (void) updateMenu;
- (void) quitProgram:(id)sender;

@property (retain, nonatomic) NSString *tickerValue;
@property (retain) Ticker *ticker;
@property (retain) NSMutableArray *stats;
@property (nonatomic) NSInteger cancelThread;

@end
