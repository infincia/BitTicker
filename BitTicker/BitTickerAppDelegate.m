/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia


 */

#import "BitTickerAppDelegate.h"
#import "MtGox.h"
@implementation BitTickerAppDelegate



- (void)awakeFromNib {    

	mtgox = [[MtGox alloc] init];
}

@end
