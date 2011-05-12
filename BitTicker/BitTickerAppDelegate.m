//  Created by steve on 5/2/10.
//  Copyright 2010 none. All rights reserved.
//

#import "BitTickerAppDelegate.h"
#import "Ticker.h"
#import "StatusItemView.h"

@interface NSMutableArray (ShiftExtension)
// returns the first element of self and removes it
-(id)shift;
@end

@implementation NSMutableArray (ShiftExtension)
-(id)shift {
    if([self count] < 1) return nil;
    id obj = [[[self objectAtIndex:0] retain] autorelease];
    [self removeObjectAtIndex:0];
    return obj;
}
@end

@implementation BitTickerAppDelegate

@synthesize stats;
@synthesize cancelThread;
@synthesize ticker = _ticker, tickerValue;

- (void)awakeFromNib {    
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem retain];
    self.tickerValue = @"0.0000";
    statusItemView = [[[StatusItemView alloc] init] retain];
	statusItemView.statusItem = _statusItem;
	[statusItemView setToolTip:NSLocalizedString(@"BitTicker",
												 @"Status Item Tooltip")];
	[_statusItem setView:statusItemView];
    
    // menu stuff
	trayMenu = [[[NSMenu alloc] initWithTitle:@""] retain];
	//graphItem  = [[NSMenuItem alloc] init];
	statsItem  = [[NSMenuItem alloc] init];
	statsView = [[NSView alloc] initWithFrame:CGRectMake(0,70,230,90)];
	[statsItem setView:statsView];
	[trayMenu addItem:statsItem];
    
	NSString *menuFont = @"LucidaGrande-Bold";
	NSInteger menuFontSize = 12;
	NSInteger menuHeight = 15;
	NSInteger labelWidth = 120;
	NSInteger valueWidth = 60;
	
	NSInteger labelOffset = 20;
	NSInteger valueOffset = 160;
	highValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,75,valueWidth,menuHeight)];
	[highValue setEditable:FALSE];
	[highValue setBordered:NO];
	[highValue setAlignment:NSRightTextAlignment];
	[highValue setBackgroundColor:[NSColor clearColor]];
	[highValue setTextColor:[NSColor blackColor]];
	[highValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:highValue];
	
	NSTextField *highLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,75,labelWidth,menuHeight)];
	[highLabel setEditable:FALSE];
	[highLabel setBordered:NO];
	[highLabel setAlignment:NSLeftTextAlignment];
	[highLabel setBackgroundColor:[NSColor clearColor]];
	[highLabel setStringValue:@"High:"];
	[highLabel setTextColor:[NSColor blackColor]];
	[highLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:highLabel];
	
	
	//
	lowValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,60,valueWidth,menuHeight)];
	[lowValue setEditable:FALSE];
	[lowValue setBordered:NO];
	[lowValue setAlignment:NSRightTextAlignment];
	[lowValue setBackgroundColor:[NSColor clearColor]];
	[lowValue setTextColor:[NSColor blackColor]];
	[lowValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:lowValue];	
	
	NSTextField *lowLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,60,labelWidth,menuHeight)];
	[lowLabel setEditable:FALSE];
	[lowLabel setBordered:NO];
	[lowLabel setAlignment:NSLeftTextAlignment];
	[lowLabel setBackgroundColor:[NSColor clearColor]];
	[lowLabel setStringValue:@"Low:"];
	[lowLabel setTextColor:[NSColor blackColor]];
	[lowLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:lowLabel];
	
	//
	buyValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,45,valueWidth,menuHeight)];
	[buyValue setEditable:FALSE];
	[buyValue setBordered:NO];
	[buyValue setAlignment:NSRightTextAlignment];
	[buyValue setBackgroundColor:[NSColor clearColor]];
	[buyValue setTextColor:[NSColor blackColor]];
	[buyValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:buyValue];	
	
	NSTextField *buyLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,45,labelWidth,menuHeight)];
	[buyLabel setEditable:FALSE];
	[buyLabel setBordered:NO];
	[buyLabel setAlignment:NSLeftTextAlignment];
	[buyLabel setBackgroundColor:[NSColor clearColor]];
	[buyLabel setStringValue:@"Buy:"];
	[buyLabel setTextColor:[NSColor blackColor]];
	[buyLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:buyLabel];
	
	//
	sellValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,30,valueWidth,menuHeight)];
	[sellValue setEditable:FALSE];
	[sellValue setBordered:NO];
	[sellValue setAlignment:NSRightTextAlignment];
	[sellValue setBackgroundColor:[NSColor clearColor]];
	[sellValue setTextColor:[NSColor blackColor]];
	[sellValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:sellValue];	
	
	NSTextField *sellLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,30,labelWidth,menuHeight)];
	[sellLabel setEditable:FALSE];
	[sellLabel setBordered:NO];
	[sellLabel setAlignment:NSLeftTextAlignment];
	[sellLabel setBackgroundColor:[NSColor clearColor]];
	[sellLabel setStringValue:@"Sell:"];
	[sellLabel setTextColor:[NSColor blackColor]];
	[sellLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:sellLabel];
	
	//
	lastValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,15,valueWidth,menuHeight)];
	[lastValue setEditable:FALSE];
	[lastValue setBordered:NO];
	[lastValue setAlignment:NSRightTextAlignment];
	[lastValue setBackgroundColor:[NSColor clearColor]];
	[lastValue setTextColor:[NSColor blackColor]];
	[lastValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:lastValue];	
	
	NSTextField *lastLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,15,labelWidth,menuHeight)];
	[lastLabel setEditable:FALSE];
	[lastLabel setBordered:NO];
	[lastLabel setAlignment:NSLeftTextAlignment];
	[lastLabel setBackgroundColor:[NSColor clearColor]];
	[lastLabel setStringValue:@"Last:"];
	[lastLabel setTextColor:[NSColor blackColor]];
	[lastLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:lastLabel];
    
    //
	volValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,0,valueWidth,menuHeight)];
	[volValue setEditable:FALSE];
	[volValue setBordered:NO];
	[volValue setAlignment:NSRightTextAlignment];
	[volValue setBackgroundColor:[NSColor clearColor]];
	[volValue setTextColor:[NSColor blackColor]];
	[volValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:volValue];	
	
	
	NSTextField *volLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,0,labelWidth,menuHeight)];
	[volLabel setEditable:FALSE];
	[volLabel setBordered:NO];
	[volLabel setAlignment:NSLeftTextAlignment];
	[volLabel setBackgroundColor:[NSColor clearColor]];
	[volLabel setStringValue:@"Volume:"];
	[volLabel setTextColor:[NSColor blackColor]];
	[volLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[statsView addSubview:volLabel];
    
    
	[trayMenu addItem:[NSMenuItem separatorItem]];
	aboutItem = [trayMenu addItemWithTitle: @"About"  
                                    action: @selector (orderFrontStandardAboutPanel:)  
                             keyEquivalent: @"a"];
	quitItem = [trayMenu addItemWithTitle: @"Quit"  
								   action: @selector (quitProgram:)  
							keyEquivalent: @"q"];
	[statusItemView setMenu:trayMenu];
	self.ticker = [[Ticker alloc] init];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"]) {
		[self startTickerThread];
		NSLog(@"Starting");
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        [self startTickerThread];
		NSLog(@"Starting");
	}
	[autoreleasepool release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
    
	
}

- (void) startTickerThread {
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	tickerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTicker) object:nil];
	[tickerThread setName:@"tickerThread"];
	[tickerThread start];
	[autoreleasepool release];
}

- (void) startTicker {
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(updateMenu) 
                           withObject:nil
                        waitUntilDone:NO];
	updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateTickerData) object:nil];
	[updateThread setName:@"updateThread"];
	[updateThread start];
	[self performSelectorOnMainThread:@selector(updateMenu) 
                           withObject:nil
                        waitUntilDone:YES];
	[autoreleasepool release];
	return;
}

- (void)updateTickerData {
	NSAutoreleasePool *mainPool = [[NSAutoreleasePool alloc] init];
 	while (1) {
		if([[NSThread currentThread] isCancelled]) {
			[mainPool release];
			[NSThread exit];
		}
		else {
			[self.ticker getTickerData];
			if ([self.ticker.outdated boolValue] == FALSE) {
                NSLog(@"Ticker updated with valid info");
                [self performSelectorOnMainThread:@selector(updateMenu) 
                                       withObject:nil
                                    waitUntilDone:NO];
			}
			else {			
				NSLog(@"Ticker Outdated!!!!!");
				[self performSelectorOnMainThread:@selector(updateMenu) 
                                       withObject:nil
                                    waitUntilDone:NO];
			}
		}
		sleep(30);
	}
	[mainPool release];
}

- (void) updateGraph {
	//[graph reloadData];
}


- (void) updateMenu {
	[statusItemView setTickerValue:self.ticker.last];
	[highValue setStringValue:[NSString stringWithFormat:@"$%0.4f",[self.ticker.high floatValue]]];
	[lowValue setStringValue:[NSString stringWithFormat:@"$%0.4f",[self.ticker.low floatValue]]];
	[volValue setStringValue:self.ticker.vol];
	[buyValue setStringValue:[NSString stringWithFormat:@"$%0.4f",[self.ticker.buy floatValue]]];
	[sellValue setStringValue: [NSString stringWithFormat:@"$%0.4f",[self.ticker.sell floatValue]]];
	[lastValue setStringValue: [NSString stringWithFormat:@"$%0.4f",[self.ticker.last floatValue]]];
}

- (void)quitProgram:(id)sender {
	[NSApp terminate:self];
}

@end
