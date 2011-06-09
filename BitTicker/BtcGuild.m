//
//  BtcGuild.m
//  BitTicker
//
//  Created by colin on 6/9/11.
//  Copyright 2011 none. All rights reserved.
//

#import "BtcGuild.h"
#import "Miner.h"

#define BTCGUILD_MINING_URL @"http://www.btcguild.com/api.php"

@implementation BtcGuild

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate {
    if (!(self = [super initWithDelegate:delegate])) return self;
    _tickerURL = @"";
	_tradeURL = @"";
	_depthURL = @"";
	_walletURL = @"";
	_minerURL = BTCGUILD_MINING_URL;
    return self;
}

-(void)fetchMiner {
    MSLog(@"Fetching miner...");
	NSString *apiKey = [sharedSettingManager apiKeyForMarket:eMarketBtcGuild];
	if ([apiKey isEqualToString:@""] || apiKey == nil) {
		return;
	}
	NSString *url = [NSString stringWithFormat:@"%@?api_key=%@",self.minerURL,apiKey];
	[self downloadJsonDataFromURL:[NSURL URLWithString:url] callback:@selector(didFetchMiner:)];
}

-(void)didFetchMiner:(NSDictionary *)minerdata {
	NSMutableDictionary *minerUser = [minerdata objectForKey:@"user"];
	Miner *newminer = [[Miner alloc] init];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	newminer.unconfirmed_reward = [formatter numberFromString:[[minerUser objectForKey:@"unconfirmed_rewards"] description]];
	newminer.confirmed_reward = [formatter numberFromString:[[minerUser objectForKey:@"confirmed_rewards"] description]];
	newminer.estimated_reward = [formatter numberFromString:[[minerUser objectForKey:@"estimated_rewards"] description]];
	//newminer.send_threshold = [formatter numberFromString:[minerUser objectForKey:@"send_threshold"]];
	//newminer.wallet = [minerUser objectForKey:@"wallet"];
	//newminer.username = [minerUser objectForKey:@"username"];
	NSMutableArray *workerArray = [NSMutableArray arrayWithCapacity:10];
	NSDictionary *dict = [minerdata objectForKey:@"workers"];
	for(NSString *key in dict) {
		NSDictionary *value = [dict objectForKey:key];
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:value];
		[tempDict setObject:[value objectForKey:@"worker_name"] forKey:@"worker_name"];
		[tempDict setObject:[value objectForKey:@"hash_rate"] forKey:@"hashrate"];
		[workerArray addObject:tempDict];
	}
	newminer.workers = workerArray;
	[formatter release];
	[_delegate bitcoinMarket:self didReceiveMiner:newminer];
}

@end
