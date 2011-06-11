//
//  TradeHillMarketMenuView.m
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TradeHillMarketMenuView.h"
#define menuFont @"LucidaGrande"
#define menuFontSize 12
#define headerFont @"LucidaGrande-Bold"
#define headerFontSize 13

#define menuHeight 15
#define labelWidth 70
#define headerWidth 120
#define valueWidth 60

#define labelOffset 20
#define valueOffset 110

@implementation TradeHillMarketMenuView

- (id)initWithFrame:(NSRect)frame {
	CGRect newFrame = frame;
	newFrame.size.height = frame.size.height + 60;
    self = [super initWithFrame:newFrame];
    if (self) {
		NSTextField *sectionLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,153,headerWidth,menuHeight)];
		[sectionLabel setEditable:FALSE];
		[sectionLabel setBordered:NO];
		[sectionLabel setAlignment:NSLeftTextAlignment];
		[sectionLabel setBackgroundColor:[NSColor clearColor]];
		[sectionLabel setStringValue:@"Trade Hill"];
		[sectionLabel setTextColor:[NSColor blueColor]];
		[sectionLabel setFont:[NSFont fontWithName:headerFont size:headerFontSize]];
		[self addSubview:sectionLabel];
		[sectionLabel release];
	
		highValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,135,valueWidth,menuHeight)];
		[highValue setEditable:FALSE];
		[highValue setBordered:NO];
		[highValue setAlignment:NSRightTextAlignment];
		[highValue setBackgroundColor:[NSColor clearColor]];
		[highValue setTextColor:[NSColor blackColor]];
		[highValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:highValue];
	
		NSTextField *highLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,135,labelWidth,menuHeight)];
		[highLabel setEditable:FALSE];
		[highLabel setBordered:NO];
		[highLabel setAlignment:NSLeftTextAlignment];
		[highLabel setBackgroundColor:[NSColor clearColor]];
		[highLabel setStringValue:@"High:"];
		[highLabel setTextColor:[NSColor blackColor]];
		[highLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:highLabel];
		[highLabel release];
		
		lowValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,120,valueWidth,menuHeight)];
		[lowValue setEditable:FALSE];
		[lowValue setBordered:NO];
		[lowValue setAlignment:NSRightTextAlignment];
		[lowValue setBackgroundColor:[NSColor clearColor]];
		[lowValue setTextColor:[NSColor blackColor]];
		[lowValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:lowValue];	
		
		NSTextField *lowLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,120,labelWidth,menuHeight)];	
		[lowLabel setEditable:FALSE];
		[lowLabel setBordered:NO];
		[lowLabel setAlignment:NSLeftTextAlignment];
		[lowLabel setBackgroundColor:[NSColor clearColor]];
		[lowLabel setStringValue:@"Low:"];
		[lowLabel setTextColor:[NSColor blackColor]];
		[lowLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:lowLabel];
		[lowLabel release];
	
		buyValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,105,valueWidth,menuHeight)];
		[buyValue setEditable:FALSE];
		[buyValue setBordered:NO];
		[buyValue setAlignment:NSRightTextAlignment];
		[buyValue setBackgroundColor:[NSColor clearColor]];
		[buyValue setTextColor:[NSColor blackColor]];
		[buyValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:buyValue];	
	
		NSTextField *buyLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,105,labelWidth,menuHeight)];
		[buyLabel setEditable:FALSE];
		[buyLabel setBordered:NO];
		[buyLabel setAlignment:NSLeftTextAlignment];
		[buyLabel setBackgroundColor:[NSColor clearColor]];
		[buyLabel setStringValue:@"Buy:"];
		[buyLabel setTextColor:[NSColor blackColor]];
		[buyLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:buyLabel];
		[buyLabel release];
	
		sellValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,90,valueWidth,menuHeight)];
		[sellValue setEditable:FALSE];
		[sellValue setBordered:NO];
		[sellValue setAlignment:NSRightTextAlignment];
		[sellValue setBackgroundColor:[NSColor clearColor]];
		[sellValue setTextColor:[NSColor blackColor]];
		[sellValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:sellValue];	
	
		NSTextField *sellLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,90,labelWidth,menuHeight)];
		[sellLabel setEditable:FALSE];
		[sellLabel setBordered:NO];
		[sellLabel setAlignment:NSLeftTextAlignment];
		[sellLabel setBackgroundColor:[NSColor clearColor]];
		[sellLabel setStringValue:@"Sell:"];
		[sellLabel setTextColor:[NSColor blackColor]];
		[sellLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:sellLabel];
		[sellLabel release];
    
		lastValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,75,valueWidth,menuHeight)];
		[lastValue setEditable:FALSE];
		[lastValue setBordered:NO];
		[lastValue setAlignment:NSRightTextAlignment];
		[lastValue setBackgroundColor:[NSColor clearColor]];
		[lastValue setTextColor:[NSColor blackColor]];
		[lastValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:lastValue];	
	
		NSTextField *lastLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,75,labelWidth,menuHeight)];
		[lastLabel setEditable:FALSE];
		[lastLabel setBordered:NO];
		[lastLabel setAlignment:NSLeftTextAlignment];
		[lastLabel setBackgroundColor:[NSColor clearColor]];
		[lastLabel setStringValue:@"Last:"];
		[lastLabel setTextColor:[NSColor blackColor]];
		[lastLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:lastLabel];
		[lastLabel release];
    
		volValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset,60,valueWidth,menuHeight)];
		[volValue setEditable:FALSE];
		[volValue setBordered:NO];
		[volValue setAlignment:NSRightTextAlignment];
		[volValue setBackgroundColor:[NSColor clearColor]];
		[volValue setTextColor:[NSColor blackColor]];
		[volValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:volValue];	
	
		NSTextField *volLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,60,labelWidth,menuHeight)];
		[volLabel setEditable:FALSE];
		[volLabel setBordered:NO];
		[volLabel setAlignment:NSLeftTextAlignment];
		[volLabel setBackgroundColor:[NSColor clearColor]];
		[volLabel setStringValue:@"Volume:"];
		[volLabel setTextColor:[NSColor blackColor]];
		[volLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:volLabel];
		[volLabel release];
    
		BTCValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 45, valueWidth, menuHeight)];
		[BTCValue setEditable:FALSE];
		[BTCValue setBordered:NO];
		[BTCValue setAlignment:NSRightTextAlignment];
		[BTCValue setBackgroundColor:[NSColor clearColor]];
		[BTCValue setTextColor:[NSColor blackColor]];
		[BTCValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:BTCValue];
    
		NSTextField *BTCLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,45,labelWidth,menuHeight)];
		[BTCLabel setEditable:FALSE];
		[BTCLabel setBordered:NO];
		[BTCLabel setAlignment:NSLeftTextAlignment];
		[BTCLabel setBackgroundColor:[NSColor clearColor]];
		[BTCLabel setStringValue:@"BTC:"];
		[BTCLabel setTextColor:[NSColor blackColor]];
		[BTCLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:BTCLabel];
		[BTCLabel release];
	
		BTCxUSDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 30, valueWidth, menuHeight)];
		[BTCxUSDValue setEditable:FALSE];
		[BTCxUSDValue setBordered:NO];
		[BTCxUSDValue setAlignment:NSRightTextAlignment];
		[BTCxUSDValue setBackgroundColor:[NSColor clearColor]];
		[BTCxUSDValue setTextColor:[NSColor blackColor]];
		[BTCxUSDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:BTCxUSDValue];
    
		NSTextField *BTCxUSDLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,30,labelWidth,menuHeight)];
		[BTCxUSDLabel setEditable:FALSE];
		[BTCxUSDLabel setBordered:NO];
		[BTCxUSDLabel setAlignment:NSLeftTextAlignment];
		[BTCxUSDLabel setBackgroundColor:[NSColor clearColor]];
		[BTCxUSDLabel setStringValue:@"BTC * Last:"];
		[BTCxUSDLabel setTextColor:[NSColor blackColor]];
		[BTCxUSDLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:BTCxUSDLabel];
		[BTCxUSDLabel release];	
	
		USDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 15, valueWidth, menuHeight)];
		[USDValue setEditable:FALSE];
		[USDValue setBordered:NO];
		[USDValue setAlignment:NSRightTextAlignment];
		[USDValue setBackgroundColor:[NSColor clearColor]];
		[USDValue setTextColor:[NSColor blackColor]];
		[USDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:USDValue];
    
		NSTextField *USDLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,15,labelWidth,menuHeight)];
		[USDLabel setEditable:FALSE];
		[USDLabel setBordered:NO];
		[USDLabel setAlignment:NSLeftTextAlignment];
		[USDLabel setBackgroundColor:[NSColor clearColor]];
		[USDLabel setStringValue:@"USD:"];
		[USDLabel setTextColor:[NSColor blackColor]];
		[USDLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:USDLabel];
		[USDLabel release];		

		walletUSDValue = [[NSTextField alloc] initWithFrame:CGRectMake(valueOffset, 0, valueWidth, menuHeight)];
		[walletUSDValue setEditable:FALSE];
		[walletUSDValue setBordered:NO];
		[walletUSDValue setAlignment:NSRightTextAlignment];
		[walletUSDValue setBackgroundColor:[NSColor clearColor]];
		[walletUSDValue setTextColor:[NSColor blackColor]];
		[walletUSDValue setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:walletUSDValue];
    
		NSTextField *walletLabel = [[NSTextField alloc] initWithFrame:CGRectMake(labelOffset,0,labelWidth,menuHeight)];
		[walletLabel setEditable:FALSE];
		[walletLabel setBordered:NO];
		[walletLabel setAlignment:NSLeftTextAlignment];
		[walletLabel setBackgroundColor:[NSColor clearColor]];
		[walletLabel setStringValue:@"Total:"];
		[walletLabel setTextColor:[NSColor blackColor]];
		[walletLabel setFont:[NSFont fontWithName:menuFont size:menuFontSize]];
		[self addSubview:walletLabel];
		[walletLabel release];	
    }
	
    return self;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    
    return self;
}
	
#pragma mark -
#pragma mark Properties

-(void)setHigh:(NSString *)string {
	[highValue setStringValue:string];
}

-(void)setLow:(NSString *)string {
	[lowValue setStringValue:string];
}

-(void)setVol:(NSString *)string {
	[volValue setStringValue:string];
}

-(void)setBuy:(NSString *)string {
	[buyValue setStringValue:string];
}

-(void)setSell:(NSString *)string {
	[sellValue setStringValue:string];
}

-(void)setLast:(NSString *)string {
	[lastValue setStringValue:string];
}
	
-(void)setBtc:(NSString *)string {
	[BTCValue setStringValue:string];
}	

-(void)setBtcusd:(NSString *)string {
	[BTCxUSDValue setStringValue:string];
}

-(void)setUsd:(NSString *)string {
	[USDValue setStringValue:string];
}

-(void)setWallet:(NSString *)string {
	[walletUSDValue setStringValue:string];
}

- (void)dealloc
{
    [super dealloc];
}
@end
