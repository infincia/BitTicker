//
//  WindowPanel.h
//  BitTicker
//
//  Created by steve on 6/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Ticker;
@class Wallet;

@interface WindowPanel : NSView {
@private
    IBOutlet NSTextField *label;
	IBOutlet NSTextField *lastField;
	IBOutlet NSTextField *buyField;
	IBOutlet NSTextField *sellField;
	IBOutlet NSTextField *highField;
	IBOutlet NSTextField *lowField;
	NSNumberFormatter *currencyFormatter;
}

-(void)didReceiveTicker:(NSNotification *)notification;

-(void)didReceiveWallet:(NSNotification *)notification;

@end
