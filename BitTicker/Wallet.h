//
//  Wallet.h
//  BitTicker
//
//  Created by steve on 6/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Wallet : NSObject {
	NSInteger   _mid;       // Market ID, 0 = MtGox
    NSNumber    *_btc;    // Wallet BTC contents
    NSNumber    *_usd;   // Wallet USD contents
}

@property (nonatomic) NSInteger mid;
@property (nonatomic, retain) NSNumber *btc;
@property (nonatomic, retain) NSNumber *usd;

@end
