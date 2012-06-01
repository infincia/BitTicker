/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import <Foundation/Foundation.h>


@class StatusItemView;

@interface Dropdown : NSObject {
	NSMenu *trayMenu;
	
	NSMutableDictionary *_viewDict;
	StatusItemView *statusItemView;
	NSStatusItem *_statusItem;
	
	NSNumberFormatter *currencyFormatter;
	NSNumberFormatter *volumeFormatter;
	
	NSNumber *_tickerValue;
	

    
}

@property (copy) NSNumber *tickerValue;

@property (retain) NSString *high;
@property (retain) NSString *low;
@property (retain) NSString *vol;
@property (retain) NSString *buy;
@property (retain) NSString *sell;
@property (retain) NSString *last;

@property (assign) IBOutlet NSView *dropdownView;

@end
