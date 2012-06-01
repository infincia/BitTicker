/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import "StatusItemView.h"
#import <QuartzCore/QuartzCore.h>

#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3
#define StatusItemWidth 50
#define ColorFadeFramerate 30.0
#define ColorFadeDuration 1.0

@implementation StatusItemView

@synthesize statusItem, previousTickerValue, colorTimer;

- (void)drawRect:(NSRect)rect {
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    
    NSPoint point = NSMakePoint(1, 1);
    NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont fontWithName:@"LucidaGrande-Bold" size:16];
    
    
    NSColor *white = [NSColor whiteColor];
    [fontAttributes setObject:font forKey:NSFontAttributeName];
    
    NSString *tickerPretty = [currencyFormatter stringFromNumber:tickerValue];
    CGSize expected = [tickerPretty sizeWithAttributes:fontAttributes];
    CGRect newFrame = self.frame;
    newFrame.size.width = expected.width + 5;
    self.frame = newFrame;
    // expexted.width might be a decimal, we don't want burry edges on our highlight.
    [statusItem setLength:(int)(expected.width+0.5)+StatusItemViewPaddingWidth];
    
    if (isMenuVisible) {
        [fontAttributes setObject:white forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:fontAttributes];
    }
    else {
        NSColor *foreground_color;
        if(isAnimating){
            NSTimeInterval duration = -1.0 * [lastUpdated timeIntervalSinceNow];
            double colorAlpha;
            
            if(duration >= ColorFadeDuration){
                [self.colorTimer invalidate];
                isAnimating = NO;
                colorAlpha = 0.0;
            } else {
                colorAlpha = 1.0 - (duration / ColorFadeDuration);
            }
            
            foreground_color = [currentColor blendedColorWithFraction:colorAlpha ofColor:flashColor];
        }
        else foreground_color = currentColor;
        
        [fontAttributes setObject:foreground_color forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:fontAttributes];
    }   
}


- (id)initWithFrame:(NSRect)frame {
	CGRect newFrame = CGRectMake(0,0,StatusItemWidth,[[NSStatusBar systemStatusBar] thickness]);
    self = [super initWithFrame:newFrame];
    
	firstTick = YES;
	self.previousTickerValue = [NSNumber numberWithInt:0];
	self.tickerValue = [NSNumber numberWithInt:0];
	flashColor = [NSColor blackColor];
	currentColor = [NSColor blackColor];
	lastUpdated = [NSDate date];
	statusItem = nil;
	isMenuVisible = NO;
	isAnimating = NO;
	[statusItem setLength:StatusItemWidth];
	
	currencyFormatter = [[NSNumberFormatter alloc] init];
	currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
	currencyFormatter.currencyCode = @"USD"; // TODO: Base on market currency
	currencyFormatter.thousandSeparator = @","; // TODO: Base on local seperator for currency
	currencyFormatter.alwaysShowsDecimalSeparator = YES;
	currencyFormatter.hasThousandSeparators = YES;
	currencyFormatter.minimumFractionDigits = 2; // TODO: Configurable
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTicker:) name:@"MtGox-Ticker" object:nil];

    return self;
}

- (void)mouseDown:(NSEvent *)event {
	NSLog(@"Menu click");
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
    // Treat right-click just like left-click
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];    
    [self setNeedsDisplay:YES];
}

- (NSColor *)ForegroundColor {
    if (isMenuVisible) {
        return [NSColor whiteColor];
    }
    else {
        return [NSColor whiteColor];
    }    
}

- (void)updateFade {
    [self setNeedsDisplay:YES];
}

- (void)setTickerValue:(NSNumber *)value {
    previousTickerValue = tickerValue;
    tickerValue = value;
    BOOL animate_color = YES;
    if(firstTick){
        firstTick = NO;
        animate_color = NO;
    } else if(tickerValue > previousTickerValue){

        flashColor = [NSColor greenColor];

        currentColor = [NSColor colorWithDeviceRed:0 green:0.55 blue:0 alpha:1.0];
		NSLog(@"Going green...");
    } else if(tickerValue < previousTickerValue){

        flashColor = [NSColor redColor];

		currentColor = [NSColor colorWithDeviceRed:0.55 green:0 blue:0 alpha:1.0];
		NSLog(@"Going red...");

    } else {
        animate_color = NO;
    }
    
    if(animate_color){
        
        self.colorTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/ColorFadeFramerate)
                                                       target:self
                                                     selector:@selector(updateFade)
                                                     userInfo:nil
                                                      repeats:YES];
        
        lastUpdated = [NSDate date];
        isAnimating = YES;
    }

    
    [self setNeedsDisplay:YES];
    

}

-(void)didReceiveTicker:(NSNotification *)notification {
	NSDictionary *ticker = [[notification object] objectForKey:@"ticker"];

	dispatch_async(dispatch_get_main_queue(), ^{
		[self setTickerValue:[ticker objectForKey:@"last"]];
	});

}

- (NSNumber *)tickerValue {
    return tickerValue;
}

@end
