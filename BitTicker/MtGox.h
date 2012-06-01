/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import <Foundation/Foundation.h>
#import "dispatch/dispatch.h"

@interface MtGox : NSObject {
	NSMutableArray *history;
	NSThread *loopThread;
	dispatch_queue_t queue;
	
}


@end
