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
#import "Wallet.h"
#import "Miner.h"
#import "StatusItemView.h"
#import "MtGoxMarket.h"
#import "BitcoinCZ.h"
#import "SharedSettings.h"

#import "SettingsWindowController.h"
#import "SettingsWindow.h"

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
    
	sharedSettingManager = [SharedSettings sharedSettingManager];
	
    settingsWindowController = [[SettingsWindowController alloc] init];
    
    // menu stuff
	trayMenu = [[NSMenu alloc] initWithTitle:@"Ticker"];
	//graphItem  = [[NSMenuItem alloc] init];
	statsItem  = [[NSMenuItem alloc] init];
	statsView = [[NSView alloc] initWithFrame:CGRectMake(0,70,180,105)];
	[statsItem setView:statsView];
	[trayMenu addItem:statsItem];
    
	NSString *menuFont = @"LucidaGrande";
	NSInteger menuFontSize = 12;
	NSString *headerFont = @"LucidaGrande-Bold";
	NSInteger headerFontSize = 13;	
	
	NSInteger menuHeight = 15;
	NSInteger labelWidth = 70;
	NSInteger headerWidth = 120;
	NSInteger valueWidth = 60;
	
	NSInteger labelOffset = 20;
	NSInteger valueOffset = 110;
	
		//section header
	NSTextField *tickerSectionLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,93,headerWidth,menuHeight)];
	[tickerSectionLabel setEditable:FALSE];
	[tickerSectionLabel setBordered:NO];
	[tickerSectionLabel setAlignment:NSLeftTextAlignment];
	[tickerSectionLabel setBackgroundColor:[NSColor clearColor]];
	[tickerSectionLabel setStringValue:@"Ticker"];
	[tickerSectionLabel setTextColor:[NSColor blueColor]];
	[tickerSectionLabel setFont:[NSFont fontWithName:headerFont size:headerFontSize]];
	[statsView addSubview:tickerSectionLabel];
    [tickerSectionLabel release];
	
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

	
	walletItem  = [[NSMenuItem alloc] init];
	walletView = [[NSView alloc] initWithFrame:CGRectMake(0,0,180,75)];
    [walletItem setView:walletView];
	[trayMenu addItem:walletItem];
	
	
	
	//section header
	NSTextField *walletSectionLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,64,headerWidth,menuHeight)];
	[walletSectionLabel setEditable:FALSE];
	[walletSectionLabel setBordered:NO];
	[walletSectionLabel setAlignment:NSLeftTextAlignment];
	[walletSectionLabel setBackgroundColor:[NSColor clearColor]];
    // TODO: Allow multiple wallets
    [walletSectionLabel setStringValue:@"MtGox Wallet"];
	[walletSectionLabel setTextColor:[NSColor blueColor]];
	[walletSectionLabel setFont:[NSFont fontWithName:headerFont size:headerFontSize]];
	[walletView addSubview:walletSectionLabel];
    [walletSectionLabel release];
	
	
	
	
	
    
    BTCValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 45, valueWidth, menuHeight)];
    [BTCValue setEditable:FALSE];
	[BTCValue setBordered:NO];
	[BTCValue setAlignment:NSRightTextAlignment];
	[BTCValue setBackgroundColor:[NSColor clearColor]];
	[BTCValue setTextColor:[NSColor blackColor]];
	[BTCValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [walletView addSubview:BTCValue];
    
    NSTextField *BTCLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,45,labelWidth,menuHeight)];
	[BTCLabel setEditable:FALSE];
	[BTCLabel setBordered:NO];
	[BTCLabel setAlignment:NSLeftTextAlignment];
	[BTCLabel setBackgroundColor:[NSColor clearColor]];
	[BTCLabel setStringValue:@"BTC:"];
	[BTCLabel setTextColor:[NSColor blackColor]];
	[BTCLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[walletView addSubview:BTCLabel];
    [BTCLabel release];
	
    BTCxUSDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 30, valueWidth, menuHeight)];
    [BTCxUSDValue setEditable:FALSE];
	[BTCxUSDValue setBordered:NO];
	[BTCxUSDValue setAlignment:NSRightTextAlignment];
	[BTCxUSDValue setBackgroundColor:[NSColor clearColor]];
	[BTCxUSDValue setTextColor:[NSColor blackColor]];
	[BTCxUSDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [walletView addSubview:BTCxUSDValue];
    
    NSTextField *BTCxUSDLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,30,labelWidth,menuHeight)];
	[BTCxUSDLabel setEditable:FALSE];
	[BTCxUSDLabel setBordered:NO];
	[BTCxUSDLabel setAlignment:NSLeftTextAlignment];
	[BTCxUSDLabel setBackgroundColor:[NSColor clearColor]];
	[BTCxUSDLabel setStringValue:@"BTC * Last:"];
	[BTCxUSDLabel setTextColor:[NSColor blackColor]];
	[BTCxUSDLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[walletView addSubview:BTCxUSDLabel];
    [BTCxUSDLabel release];	
	
	
	
    USDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 15, valueWidth, menuHeight)];
    [USDValue setEditable:FALSE];
	[USDValue setBordered:NO];
	[USDValue setAlignment:NSRightTextAlignment];
	[USDValue setBackgroundColor:[NSColor clearColor]];
	[USDValue setTextColor:[NSColor blackColor]];
	[USDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [walletView addSubview:USDValue];
    
    NSTextField *USDLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,15,labelWidth,menuHeight)];
	[USDLabel setEditable:FALSE];
	[USDLabel setBordered:NO];
	[USDLabel setAlignment:NSLeftTextAlignment];
	[USDLabel setBackgroundColor:[NSColor clearColor]];
	[USDLabel setStringValue:@"USD:"];
	[USDLabel setTextColor:[NSColor blackColor]];
	[USDLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[walletView addSubview:USDLabel];
    [USDLabel release];		
	
	
	
    walletUSDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 0, valueWidth, menuHeight)];
    [walletUSDValue setEditable:FALSE];
	[walletUSDValue setBordered:NO];
	[walletUSDValue setAlignment:NSRightTextAlignment];
	[walletUSDValue setBackgroundColor:[NSColor clearColor]];
	[walletUSDValue setTextColor:[NSColor blackColor]];
	[walletUSDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [walletView addSubview:walletUSDValue];
    
    NSTextField *walletLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,0,labelWidth,menuHeight)];
	[walletLabel setEditable:FALSE];
	[walletLabel setBordered:NO];
	[walletLabel setAlignment:NSLeftTextAlignment];
	[walletLabel setBackgroundColor:[NSColor clearColor]];
	[walletLabel setStringValue:@"Total:"];
	[walletLabel setTextColor:[NSColor blackColor]];
	[walletLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[walletView addSubview:walletLabel];
    [walletLabel release];			
	
	
	
	
	
	
	[trayMenu addItem:[NSMenuItem separatorItem]];
	
	
	minerItem  = [[NSMenuItem alloc] init];
	minerView = [[NSView alloc] initWithFrame:CGRectMake(0,0,180,75)];
    [minerItem setView:minerView];
	[trayMenu addItem:minerItem];
	
	//section header
	NSTextField *minerSectionLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,64,headerWidth,menuHeight)];
	[minerSectionLabel setEditable:FALSE];
	[minerSectionLabel setBordered:NO];
	[minerSectionLabel setAlignment:NSLeftTextAlignment];
	[minerSectionLabel setBackgroundColor:[NSColor clearColor]];
    [minerSectionLabel setStringValue:@"Miner Data"];
	[minerSectionLabel setTextColor:[NSColor blueColor]];
	[minerSectionLabel setFont:[NSFont fontWithName:headerFont size:headerFontSize]];
	[minerView addSubview:minerSectionLabel];
    [minerSectionLabel release];
	
    confirmedReward = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 45, valueWidth, menuHeight)];
    [confirmedReward setEditable:FALSE];
	[confirmedReward setBordered:NO];
	[confirmedReward setAlignment:NSRightTextAlignment];
	[confirmedReward setBackgroundColor:[NSColor clearColor]];
	[confirmedReward setTextColor:[NSColor blackColor]];
	[confirmedReward setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [minerView addSubview:confirmedReward];
    
    NSTextField *confirmedRewardLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,45,labelWidth,menuHeight)];
	[confirmedRewardLabel setEditable:FALSE];
	[confirmedRewardLabel setBordered:NO];
	[confirmedRewardLabel setAlignment:NSLeftTextAlignment];
	[confirmedRewardLabel setBackgroundColor:[NSColor clearColor]];
	[confirmedRewardLabel setStringValue:@"Confirmed:"];
	[confirmedRewardLabel setTextColor:[NSColor blackColor]];
	[confirmedRewardLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[minerView addSubview:confirmedRewardLabel];
    [confirmedRewardLabel release];
	
    unconfirmedReward = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 30, valueWidth, menuHeight)];
    [unconfirmedReward setEditable:FALSE];
	[unconfirmedReward setBordered:NO];
	[unconfirmedReward setAlignment:NSRightTextAlignment];
	[unconfirmedReward setBackgroundColor:[NSColor clearColor]];
	[unconfirmedReward setTextColor:[NSColor blackColor]];
	[unconfirmedReward setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [minerView addSubview:unconfirmedReward];
    
    NSTextField *unconfirmedRewardLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,30,labelWidth,menuHeight)];
	[unconfirmedRewardLabel setEditable:FALSE];
	[unconfirmedRewardLabel setBordered:NO];
	[unconfirmedRewardLabel setAlignment:NSLeftTextAlignment];
	[unconfirmedRewardLabel setBackgroundColor:[NSColor clearColor]];
	[unconfirmedRewardLabel setStringValue:@"Unconfirmed:"];
	[unconfirmedRewardLabel setTextColor:[NSColor blackColor]];
	[unconfirmedRewardLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[minerView addSubview:unconfirmedRewardLabel];
    [unconfirmedRewardLabel release];	
	
	
	
    estimatedReward = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 15, valueWidth, menuHeight)];
    [estimatedReward setEditable:FALSE];
	[estimatedReward setBordered:NO];
	[estimatedReward setAlignment:NSRightTextAlignment];
	[estimatedReward setBackgroundColor:[NSColor clearColor]];
	[estimatedReward setTextColor:[NSColor blackColor]];
	[estimatedReward setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [minerView addSubview:estimatedReward];
    
    NSTextField *estimatedRewardLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,15,labelWidth,menuHeight)];
	[estimatedRewardLabel setEditable:FALSE];
	[estimatedRewardLabel setBordered:NO];
	[estimatedRewardLabel setAlignment:NSLeftTextAlignment];
	[estimatedRewardLabel setBackgroundColor:[NSColor clearColor]];
	[estimatedRewardLabel setStringValue:@"Estimated:"];
	[estimatedRewardLabel setTextColor:[NSColor blackColor]];
	[estimatedRewardLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[minerView addSubview:estimatedRewardLabel];
    [estimatedRewardLabel release];		
	
	
	
    hashOutput = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 0, valueWidth, menuHeight)];
    [hashOutput setEditable:FALSE];
	[hashOutput setBordered:NO];
	[hashOutput setAlignment:NSRightTextAlignment];
	[hashOutput setBackgroundColor:[NSColor clearColor]];
	[hashOutput setTextColor:[NSColor blackColor]];
	[hashOutput setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
    [minerView addSubview:hashOutput];
    
    NSTextField *hashOutputLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,0,labelWidth,menuHeight)];
	[hashOutputLabel setEditable:FALSE];
	[hashOutputLabel setBordered:NO];
	[hashOutputLabel setAlignment:NSLeftTextAlignment];
	[hashOutputLabel setBackgroundColor:[NSColor clearColor]];
	[hashOutputLabel setStringValue:@"MHash/s:"];
	[hashOutputLabel setTextColor:[NSColor blackColor]];
	[hashOutputLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
	[minerView addSubview:hashOutputLabel];
    [hashOutputLabel release];			
	
	
	
	
	
	
	[trayMenu addItem:[NSMenuItem separatorItem]];
    
    refreshItem = [trayMenu addItemWithTitle:@"Refresh" 
                                      action:@selector(refreshTicker:) 
                               keyEquivalent:@"r"];
	aboutItem = [trayMenu addItemWithTitle: @"About"  
                                    action: @selector (showAbout:)  
                             keyEquivalent: @"a"];
	settingsItem = [trayMenu addItemWithTitle: @"Settings"  
                                    action: @selector (showSettings:)  
                             keyEquivalent: @"s"];
							 
							 
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
    


    MSLog(@"Starting");
    market = [[MtGoxMarket alloc] initWithDelegate:self];
	miner = [[BitcoinCZ alloc] initWithDelegate:self];
    
    tickerTimer = [[NSTimer scheduledTimerWithTimeInterval:30 target:market selector:@selector(fetchTicker) userInfo:nil repeats:YES] retain];
    walletTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:market selector:@selector(fetchWallet) userInfo:nil repeats:YES] retain];
	minerTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:miner selector:@selector(fetchMiner) userInfo:nil repeats:YES] retain];
    
    [market fetchTicker];
	[market fetchWallet];
	[miner fetchMiner];
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
    
    [settingsWindowController release];
    
	//ticker stuff
    [highValue release];
	[lowValue release];
	[volValue release];
	[buyValue release];
	[sellValue release];
	[lastValue release];
	
	//wallet stuff
	[BTCValue release];
	[BTCxUSDValue release];
	[USDValue release];
    [walletUSDValue release];
    
}

- (IBAction)showAbout:(id)sender {
	[NSApp orderFrontStandardAboutPanel:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)showSettings:(id)sender {
    [settingsWindowController.window makeKeyAndOrderFront:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

-(void)settingsWindowClosed {
    
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
	self.tickerValue = ticker.last;
    MSLog(@"Got mah ticker: %@",ticker);
    
    [highValue setStringValue:[currencyFormatter stringFromNumber:ticker.high]];
	[lowValue setStringValue:[currencyFormatter stringFromNumber:ticker.low]];
	[buyValue setStringValue:[currencyFormatter stringFromNumber:ticker.buy]];
	[sellValue setStringValue: [currencyFormatter stringFromNumber:ticker.sell]];
	[lastValue setStringValue: [currencyFormatter stringFromNumber:ticker.last]];
    
    NSNumberFormatter *volumeFormatter = [[NSNumberFormatter alloc] init];
    volumeFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    volumeFormatter.hasThousandSeparators = YES;
    [volValue setStringValue:[volumeFormatter stringFromNumber:ticker.volume]];
    
    [volumeFormatter release];
}

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveRecentTradesData:(NSArray*)trades {
    
}

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveWallet:(Wallet*)wallet {
    double btc = [wallet.btc doubleValue];
    double usd = [wallet.usd doubleValue];
	[BTCValue setStringValue:[NSString stringWithFormat:@"%f.04",[wallet.btc floatValue]]];
	[USDValue setStringValue:[currencyFormatter stringFromNumber:wallet.usd]];
	
	double last = [self.tickerValue doubleValue];
	if (last == 0) {
		//no last yet so cant multiply anyway
	}
	else {
		NSNumber *BTCxRate = [NSNumber numberWithDouble:btc*last];
		[BTCxUSDValue setStringValue:[currencyFormatter stringFromNumber:BTCxRate]];
	
		NSNumber *walletUSD = [NSNumber numberWithDouble:[BTCxRate doubleValue] + usd];
		[walletUSDValue setStringValue: [currencyFormatter stringFromNumber:walletUSD]];
		
	}
}

-(void)bitcoinMarket:(BitcoinMarket*)market didReceiveMiner:(Miner*)minerdata {
	[unconfirmedReward setStringValue:[minerdata.unconfirmed_reward stringValue]];
	[confirmedReward setStringValue:[minerdata.confirmed_reward stringValue]];
	[estimatedReward setStringValue:[minerdata.estimated_reward stringValue]];
	double hashcount;
	for (NSDictionary *worker in minerdata.workers) {
		hashcount = hashcount + [[worker objectForKey:@"hashrate"] doubleValue];
	}
	NSNumberFormatter *hashFormatter = [[NSNumberFormatter alloc] init];
    hashFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    hashFormatter.hasThousandSeparators = YES;
   	[hashOutput setStringValue:[hashFormatter stringFromNumber:[NSNumber numberWithDouble:hashcount]]];
    
    [hashFormatter release];
}

@end
