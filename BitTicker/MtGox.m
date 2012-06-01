/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import	"dispatch/dispatch.h"

#import "MtGox.h"

#import "AFJSONRequestOperation.h"

static NSString *mtgox_ticker_url = @"https://mtgox.com/code/data/ticker.php";

@implementation MtGox

-(id)init {
    self = [super init];
	history = [NSMutableArray new];
	
	queue = dispatch_queue_create("com.infincia.BitTicker.mtgox.queue", nil);
    loopThread = [[NSThread alloc] initWithTarget:self selector:@selector(loop) object:nil];
    [loopThread setName:@"loop"];
    [loopThread start];

    return self;
}


- (void) loop {	
	@autoreleasepool {
		NSLog(@"New loop");
		while (1) {
			NSLog(@"Firing loop cycle");
			if ([[NSThread currentThread] isCancelled]) {
				NSLog(@"Thread canceled");
				return;
			}
			NSURL *url = [NSURL URLWithString:mtgox_ticker_url];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
				NSLog(@"Request successful");
				
				NSMutableDictionary *message = [NSMutableDictionary new];
				NSDictionary *tickerDict = [JSON objectForKey:@"ticker"];
				
				// capped stack, new tickers pushed on top, store 1440 minutes of data
				if ([history count] >= 1440) {
					[history removeLastObject];
				}
				[history insertObject:tickerDict atIndex:0];
				
				
				[message setObject:tickerDict forKey:@"ticker"];
				[message setObject:history forKey:@"history"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"MtGox-Ticker" object:message];		
				NSLog(@"Dispatched ticker data");				
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
				//
				NSLog(@"Request failed");
			}];
			[operation start];	
			[NSThread sleepForTimeInterval:60];
		}	
	}
}


@end
