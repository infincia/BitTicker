//
//  CustomMenuView.m
//  BitTicker
//
//  Created by steve on 6/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CustomMenuView.h"


@implementation CustomMenuView

@dynamic high;
@dynamic low;
@dynamic vol;
@dynamic buy;
@dynamic sell;
@dynamic last;
	
@dynamic btc;
@dynamic btcusd;
@dynamic usd;
@dynamic wallet;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
	
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

#pragma mark -
#pragma mark Properties

// Override these

-(void)setHigh:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setLow:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setVol:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setBuy:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setSell:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setLast:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}
	
-(void)setBtc:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}	

-(void)setBtcusd:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setUsd:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

-(void)setWallet:(NSString *)string {
	[NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by CustomMenuView subclasses",__func__];

}

@end
