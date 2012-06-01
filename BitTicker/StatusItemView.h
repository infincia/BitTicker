/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView <NSMenuDelegate> {
    NSStatusItem *statusItem;
    NSNumber *tickerValue;
    NSNumber *previousTickerValue;
    NSDate *lastUpdated;
    NSTimer *colorTimer;
    NSColor *flashColor;
	NSColor *currentColor;
    BOOL isMenuVisible;
    BOOL isAnimating;
    BOOL firstTick;
	NSNumberFormatter *currencyFormatter;
}

@property (retain) NSStatusItem *statusItem;
@property (retain) NSNumber *tickerValue;
@property (retain) NSNumber *previousTickerValue;
@property (retain) NSTimer *colorTimer;

- (void)setTickerValue:(NSNumber *)value;

@end