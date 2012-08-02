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

@property (strong) NSString *high;
@property (strong) NSString *low;
@property (strong) NSString *vol;
@property (strong) NSString *buy;
@property (strong) NSString *sell;
@property (strong) NSString *last;

@property (strong) IBOutlet NSView *dropdownView;

@end
