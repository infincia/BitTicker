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

@property (strong) NSStatusItem *statusItem;
@property (strong) NSNumber *tickerValue;
@property (strong) NSNumber *previousTickerValue;
@property (strong) NSTimer *colorTimer;

- (void)setTickerValue:(NSNumber *)value;

@end