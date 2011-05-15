/*
 BitTicker is Copyright 2011 Stephen Oliver
 http://github.com/mrsteveman1
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */

#import "BitTickerAppDelegate.h"
#import "Ticker.h"
#import "StatusItemView.h"

#import "MtGoxMarket.h"

@implementation BitTickerAppDelegate

@synthesize stats;
@synthesize cancelThread;
@synthesize tickerValue;

- (void)awakeFromNib {    
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem retain];
    
    statusItemView = [[StatusItemView alloc] init];
	statusItemView.statusItem = _statusItem;
	[statusItemView setToolTip:NSLocalizedString(@"BitTicker",
												 @"Status Item Tooltip")];
	[_statusItem setView:statusItemView];
    
    // menu stuff
	trayMenu = [[NSMenu alloc] initWithTitle:@"Ticker"];
	//graphItem  = [[NSMenuItem alloc] init];
	statsItem  = [[NSMenuItem alloc] init];
	statsView = [[NSView alloc] initWithFrame:CGRectMake(0,70,180,90)];
	[statsItem setView:statsView];
	[trayMenu addItem:statsItem];
    
	NSString *menuFont = @"LucidaGrande";
	NSInteger menuFontSize = 12;
	NSInteger menuHeight = 15;
	NSInteger labelWidth = 70;
	NSInteger valueWidth = 60;
	
	NSInteger labelOffset = 20;
	NSInteger valueOffset = 110;
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
    [highLabel release];
	
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
    [lowLabel release];
	
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
    [buyLabel release];
	
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
	[sellLabel release];
    
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
    [lastLabel release];
    
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
    [volLabel release];
    
    
	[trayMenu addItem:[NSMenuItem separatorItem]];
    
    technicalsItem  = [[NSMenuItem alloc] init];
	technicalsView = [[NSView alloc] initWithFrame:CGRectMake(0,0,180,13)];
    [technicalsItem setView:technicalsView];
	[trayMenu addItem:technicalsItem];
    
    spreadValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 0, valueWidth, menuHeight)];
    [spreadValue setEditable:FALSE];
	[spreadValue setBordered:NO];
	[spreadValue setAlignment:NSRightTextAlignment];
	[spreadValue setBackgroundColor:[NSColor clearColor]];
	[spreadValue setTextColor:[NSColor blackColor]];
	[spreadValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [technicalsView addSubview:spreadValue];
    
    NSTextField *spreadLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,0,labelWidth,menuHeight)];
	[spreadLabel setEditable:FALSE];
	[spreadLabel setBordered:NO];
	[spreadLabel setAlignment:NSLeftTextAlignment];
	[spreadLabel setBackgroundColor:[NSColor clearColor]];
	[spreadLabel setStringValue:@"Spread:"];
	[spreadLabel setTextColor:[NSColor blackColor]];
	[spreadLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[technicalsView addSubview:spreadLabel];
    [spreadLabel release];
    
    [trayMenu addItem:[NSMenuItem separatorItem]];
    
    
    refreshItem = [trayMenu addItemWithTitle:@"Refresh" 
                                      action:@selector(refreshTicker:) 
                               keyEquivalent:@"r"];
	aboutItem = [trayMenu addItemWithTitle: @"About"  
                                    action: @selector (orderFrontStandardAboutPanel:)  
                             keyEquivalent: @"a"];
	quitItem = [trayMenu addItemWithTitle: @"Quit"  
								   action: @selector (quitProgram:)  
							keyEquivalent: @"q"];
    
    
	[statusItemView setMenu:trayMenu];
	
    
    currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter.currencyCode = @"USD"; // TODO: Base on market currency
    currencyFormatter.thousandSeparator = @","; // TODO: Base on local seperator for currency
    currencyFormatter.alwaysShowsDecimalSeparator = YES;
    currencyFormatter.hasThousandSeparators = YES;
    currencyFormatter.minimumFractionDigits = 4; // TODO: Configurable
    
    
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"]) {
		
	} else {
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    MSLog(@"Starting");
    market = [[MtGoxMarket alloc] initWithDelegate:self];
    
    tickerTimer = [[NSTimer scheduledTimerWithTimeInterval:30 target:market selector:@selector(fetchTicker) userInfo:nil repeats:YES] retain];
    
    [market fetchTicker];
    
}

- (void) updateGraph {
	//[graph reloadData];
}
#pragma mark Application delegate

- (void)applicationWillTerminate:(NSNotification *)notification {
    [market release];
    [tickerTimer invalidate];
    [tickerTimer release];
    [_statusItem release];
    [statusItemView release];
    [trayMenu release];
    [statsItem release];
    [currencyFormatter release];
    
    [highValue release];
	[lowValue release];
	[volValue release];
	[buyValue release];
	[sellValue release];
	[lastValue release];
    [spreadValue release];
    
    [technicalsItem release];
    [technicalsView release];
    
}

#pragma mark Actions
- (void)quitProgram:(id)sender {
	[NSApp terminate:self];
}
- (void)refreshTicker:(id)sender {
    [market fetchTicker];
}

#pragma mark Bitcoin market delegate
// A request failed for some reason, for example the API being down
-(void)bitcoinMarket:(BitcoinMarket*)market requestFailedWithError:(NSError*)error {
    MSLog(@"Error: %@",error);
}

// Request wasn't formatted as expected
-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveInvalidResponse:(NSData*)data {
    MSLog(@"Invalid response: %@",data);
}

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveTicker:(Ticker*)ticker {
    [statusItemView setTickerValue:ticker.last];
    MSLog(@"Got mah ticker: %@",ticker);
    
    [highValue setStringValue:[currencyFormatter stringFromNumber:ticker.high]];
	[lowValue setStringValue:[currencyFormatter stringFromNumber:ticker.low]];
	[buyValue setStringValue:[currencyFormatter stringFromNumber:ticker.buy]];
	[sellValue setStringValue: [currencyFormatter stringFromNumber:ticker.sell]];
	[lastValue setStringValue: [currencyFormatter stringFromNumber:ticker.last]];
    
    NSNumberFormatter *volumeFormatter = [[NSNumberFormatter alloc] init];
    volumeFormatter.hasThousandSeparators = YES;
    [volValue setStringValue:[volumeFormatter stringFromNumber:ticker.volume]];
    
    [volumeFormatter release];
    
    double ask = [ticker.sell doubleValue];
    double bid = [ticker.buy doubleValue];
    NSNumber *spread = [NSNumber numberWithDouble:ask-bid];
    [spreadValue setStringValue:[currencyFormatter stringFromNumber:spread]];
}

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveRecentTradesData:(NSArray*)trades {
    
}

@end
