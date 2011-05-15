//
//  RequestHandler.m
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import "RequestHandler.h"

#import "TaggedNSURLConnection.h"

@implementation RequestHandler
@synthesize delegate=_delegate;

-(id)initWithDelegate:(id<RequestHandlerDelegate>)requestDelegate {
    if (!(self = [super init])) return self;
    
    if (!requestDelegate) {
        MSLog(@"RequestHandler requires a delegate!");
        [self release];
        return false;
    }
    
    self.delegate = requestDelegate;
    _connectionData = [[NSMutableDictionary alloc] init];
    
    _currentTag = 0;
    _activeRequests = 0;
    
    return self;
}

-(void)dealloc {
    [self cancelAllRequests];
    [_connections release];
    [_connectionData release];
    [super dealloc];
}

-(NSInteger)startConnection:(NSURLRequest*)newRequest {
    if (!newRequest) {
        MSLog(@"No request passed to startConnection");
        return false;
    }
    
    TaggedNSURLConnection *connection = [[TaggedNSURLConnection alloc] initWithRequest:newRequest delegate:self];
    
    NSInteger newTag = _currentTag++;
    connection.tag = newTag;
    
    [_connections setObject:connection forIntegerKey:newTag];
    [_connectionData setObject:[NSMutableData dataWithLength:0] forIntegerKey:newTag];
    [connection start];
    _activeRequests++;
    
    [connection release];
    
    return newTag;
}
-(void)cancelAllRequests {
    for(NSString *key in _connections) {
        TaggedNSURLConnection *connection = [_connections objectForKey:key];
        [connection cancel];
    }
    _activeRequests = 0;
}
#pragma mark - NSURLConnection methods 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    TaggedNSURLConnection *taggedConnection = (TaggedNSURLConnection*)connection;
    
    NSMutableData *existingData = [_connectionData objectForIntegerKey:taggedConnection.tag];
    [existingData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TaggedNSURLConnection *taggedConnection = (TaggedNSURLConnection*)connection;
    _activeRequests--;
    
    [_delegate request:taggedConnection.tag didFinishWithData:[_connectionData objectForIntegerKey:taggedConnection.tag]];
    
    [_connections removeObjectForInteger:taggedConnection.tag];
    [_connectionData removeObjectForInteger:taggedConnection.tag];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //TaggedNSURLConnection *taggedConnection = (TaggedNSURLConnection*)connection;
    
    //MSLog(@"Connection %i got response %@", taggedConnection.tag, response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    TaggedNSURLConnection *taggedConnection = (TaggedNSURLConnection*)connection;
    MSLog(@"Connection %i failed with error %@", taggedConnection.tag, error);
    _activeRequests--;
    [_delegate request:taggedConnection.tag didFailWithError:error];
    
    [_connections removeObjectForInteger:taggedConnection.tag];
    [_connectionData removeObjectForInteger:taggedConnection.tag];
    
}
@end
