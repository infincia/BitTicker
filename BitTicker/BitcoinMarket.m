//
//  BitcoinMarket.m
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/27/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import "BitcoinMarket.h"

#import "RequestHandler.h"

#import "JSON.h"
#import "SharedSettings.h"
@implementation BitcoinMarket

@synthesize delegate=_delegate;
@synthesize tickerURL = _tickerURL;
@synthesize tradeURL = _tradeURL;
@synthesize walletURL = _walletURL;
@synthesize depthURL = _depthURL;

-(id)initWithDelegate:(id<BitcoinMarketDelegate>)delegate {
    if (!(self = [super init])) return self;
    
    requestHandler = [[RequestHandler alloc] initWithDelegate:self];
    self.delegate = delegate;
    _selectorMap = [[NSMutableDictionary alloc] init];
    sharedSettingManager = [SharedSettings sharedSettingManager];
    return self;
}

-(void)dealloc {
    [requestHandler release];
    [_selectorMap release];
    [super dealloc];
}

#pragma mark - Market request methods

#pragma mark - Downloading methods
-(void)downloadJsonDataFromURL:(NSURL*)url callback:(SEL)callback {
    [self downloadJsonDataFromURL:url withPostData:nil callback:callback];
}
-(void)downloadJsonDataFromURL:(NSURL *)url withPostData:(NSDictionary*)postData callback:(SEL)callback {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *body = [NSMutableString string];
    
    if (postData) {
        [urlRequest setHTTPMethod:@"POST"];
        BOOL appendAmpersand = NO;
        for(NSString *key in postData) {
            NSString *value = [postData objectForKey:key];
            [body appendFormat:@"%@=%@%@",key,value,appendAmpersand?@"":@"&"];
            if (!appendAmpersand) appendAmpersand = YES;
        }
		
		[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    } else {
        [urlRequest setHTTPMethod:@"GET"];
    }
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSInteger newTag = [requestHandler startConnection:urlRequest];
    
    NSMethodSignature *signature = [self methodSignatureForSelector:callback];
    NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:signature];
    [invoke setTarget:self];
    [invoke setSelector:callback];
    
    [_selectorMap setObject:invoke forIntegerKey:newTag];
    
}

#pragma mark - MultiConnectionHandlerDelegate methods
-(void)request:(NSInteger)tag didFinishWithData:(NSData*)data {
    // TODO: Don't assume a JSON response
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSString *jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    //MSLog(@"About to parse string: %@",jsonString);
    
    
    NSInvocation *invocation = [_selectorMap objectForIntegerKey:tag];
    
    [invocation setTarget:self];
    
    
    NSError *error = nil;
    id results = [jsonParser objectWithString:jsonString error:&error];
    
    if (error) {
        MSLog(@"ERROR from connection %i: %@",tag,error);
        id<BitcoinMarketDelegate> delegate = invocation.target;
        [delegate bitcoinMarket:self requestFailedWithError:error];
        MSLog(@"Raw data: %@",data);
    } else {
        [invocation setArgument:&results atIndex:2];
        [invocation invoke];
    }
    
    [jsonParser release];
    
    [_selectorMap removeObjectForInteger:tag];
}

-(void)request:(NSInteger)tag didFailWithError:(NSError*)error {
    
}

#pragma mark - Methods for subclasses to overwrite
-(NSURL*)getTickerDataURL {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
    return nil;
}
-(NSURL*)getRecentTradeURL {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
    return nil;
}
-(void)fetchRecentTrades {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
}
-(void)fetchTicker {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
}
-(void)fetchMarketDepth {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
}
-(void)fetchWallet {
    [NSException raise:@"MethodNotOverwrittenException" format:@"%s must be overwritten by BitcoinMarket subclasses",__func__];
}

@end
