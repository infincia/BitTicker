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
