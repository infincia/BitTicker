//
//  BitcoinCZ.m
//  BitTicker
//
//  Created by steve on 6/8/11.
//  Copyright 2011 none. All rights reserved.
//

#import "BitcoinCZ.h"
#import "Miner.h"
#define BITCOINCZ_MINING_URL @"http://mining.bitcoin.cz/accounts/profile/json"

@implementation BitcoinCZ

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate {
    if (!(self = [super initWithDelegate:delegate])) return self;
    _tickerURL = @"";
	_tradeURL = @"";
	_depthURL = @"";
	_walletURL = @"";
	_minerURL = BITCOINCZ_MINING_URL;
    return self;
}

-(void)fetchMiner {
    MSLog(@"Fetching miner...");
	NSString *apiKey = [sharedSettingManager apiKeyForMarket:eMarketBitcoinCZ];
	if ([apiKey isEqualToString:@""] || apiKey == nil) {
		return;
	}
	NSString *url = [NSString stringWithFormat:@"%@/%@",self.minerURL,apiKey];
	[self downloadJsonDataFromURL:[NSURL URLWithString:url] callback:@selector(didFetchMiner:)];
}

-(void)didFetchMiner:(NSDictionary *)minerdata {
	Miner *newminer = [[Miner alloc] init];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	newminer.unconfirmed_reward = [formatter numberFromString:[minerdata objectForKey:@"unconfirmed_reward"]];
	newminer.confirmed_reward = [formatter numberFromString:[minerdata objectForKey:@"confirmed_reward"]];
	newminer.estimated_reward = [formatter numberFromString:[minerdata objectForKey:@"estimated_reward"]];
	newminer.send_threshold = [formatter numberFromString:[minerdata objectForKey:@"send_threshold"]];
	newminer.wallet = [minerdata objectForKey:@"wallet"];
	newminer.username = [minerdata objectForKey:@"username"];
	NSMutableArray *workerArray = [NSMutableArray arrayWithCapacity:10];
	NSDictionary *dict = [minerdata objectForKey:@"workers"];
	for(NSString *key in dict) {
		NSDictionary *value = [dict objectForKey:key];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:value];
		[tempDict setObject:key forKey:@"worker_name"];
		[workerArray addObject:tempDict];
	}
	newminer.workers = workerArray;
	[formatter release];
	[_delegate bitcoinMarket:self didReceiveMiner:newminer];
}

@end
