//
//  WindowPanel.m
//  BitTicker
//
//  Created by steve on 6/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "WindowPanel.h"
#import "Ticker.h"
#import "Wallet.h"


@implementation WindowPanel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		currencyFormatter = [[NSNumberFormatter alloc] init];
		currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
		currencyFormatter.currencyCode = @"USD"; // TODO: Base on market currency
		currencyFormatter.thousandSeparator = @","; // TODO: Base on local seperator for currency
		currencyFormatter.alwaysShowsDecimalSeparator = YES;
		currencyFormatter.hasThousandSeparators = YES;
		currencyFormatter.minimumFractionDigits = 4; // TODO: Configurable
    }
    
    return self;
}

-(void)didReceiveTicker:(NSNotification *)notification {
	Ticker *ticker = [notification object];
	[lastField setStringValue:[currencyFormatter stringFromNumber:ticker.last]];
	[highField setStringValue:[currencyFormatter stringFromNumber:ticker.high]];
	[lowField setStringValue:[currencyFormatter stringFromNumber:ticker.low]];
	[buyField setStringValue:[currencyFormatter stringFromNumber:ticker.buy]];
	[sellField setStringValue:[currencyFormatter stringFromNumber:ticker.sell]];

}

-(void)didReceiveWallet:(NSNotification *)notification {
	Wallet *wallet = [notification object];
}


// A request failed for some reason, for example the API being down
-(void)requestFailedWithError:(NSNotification *)notification {
	NSError *error = [notification object];
}

// Request wasn't formatted as expected
-(void)didReceiveInvalidResponse:(NSNotification *)notification {
	NSData *data = [notification object];
}

-(void)didReceiveRecentTradesData:(NSNotification *)notification {
	NSArray *trades = [notification object];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
