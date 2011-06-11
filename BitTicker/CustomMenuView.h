//
//  CustomMenuView.h
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CustomMenuView : NSView {

    
}

- (id)initWithFrame:(NSRect)frame;

@property (retain) NSString *high;
@property (retain) NSString *low;
@property (retain) NSString *vol;
@property (retain) NSString *buy;
@property (retain) NSString *sell;
@property (retain) NSString *last;
	
@property (retain) NSString *btc;
@property (retain) NSString *btcusd;
@property (retain) NSString *usd;
@property (retain) NSString *wallet;

@end
