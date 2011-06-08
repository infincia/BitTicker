//
//  Miner.h
//  BitTicker
//
//  Created by steve on 6/8/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Miner : NSObject {
	NSString *_username;
	NSNumber *_unconfirmed_reward;
	NSNumber *_send_threshold;
	NSNumber *_confirmed_reward;
	NSNumber *_estimated_reward;
	NSString *_wallet;
	NSArray *_workers;
}

@property (retain) NSString *username;
@property (retain) NSNumber *unconfirmed_reward;
@property (retain) NSNumber *confirmed_reward;
@property (retain) NSNumber *estimated_reward;
@property (retain) NSNumber *send_threshold;
@property (retain) NSString *wallet;
@property (retain) NSArray *workers;

@end