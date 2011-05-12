//
//  MIFIDevice.m
//  Mi-Fi Manager
//
//  Created by steve on 5/2/10.
//  Copyright 2010 none. All rights reserved.
//

#import "Ticker.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
#import "JSON.h"
//#import "Element.h"
//#import "DocumentRoot.h"

@implementation Ticker

@synthesize request;
@synthesize currentError;
@synthesize high, low, vol, buy, sell, last;
@synthesize outdated;


- (id) init {
	[super init];
	self.high = @"0.0000";
    self.low = @"0.0000";
    self.vol = @"0.0000";
    self.buy = @"0.0000";
    self.sell = @"0.0000";
    self.last = @"0.0000";
	return self;
}
	 
- (void) getTickerData {
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	apiAddress = [NSString stringWithString:@"https://mtgox.com/code/data/ticker.php"];
	self.request = nil;
	self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:apiAddress]];

	self.request.timeOutSeconds = 10;
	self.request.secondsToCache = 0;
	[self.request startSynchronous];
	//NSLog(@"response: %@",[publicRequest responseString]);
	if (self.request.error) {
        NSLog(@"got request error");
        self.outdated = [NSNumber numberWithInt:1];
        self.currentError = [self.request.error localizedDescription];
        [autoreleasepool release];
        return;
	}
    NSDictionary *dict = [self.request.responseString JSONValue];
    self.outdated = 0;
    self.high = [[dict objectForKey:@"ticker"] objectForKey:@"high"];
    self.low = [[dict objectForKey:@"ticker"] objectForKey:@"low"];
    self.vol = [[dict objectForKey:@"ticker"] objectForKey:@"vol"];
    self.buy = [[dict objectForKey:@"ticker"] objectForKey:@"buy"];
    self.sell = [[dict objectForKey:@"ticker"] objectForKey:@"sell"];
    self.last = [[dict objectForKey:@"ticker"] objectForKey:@"last"];
	[autoreleasepool release];
}


-(void)dealloc {
	[self.request release];
	[super dealloc];
}

@end
