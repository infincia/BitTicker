//
//  RequestHandler.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//
//  Wrapper around NSURLRequest which will handle multiple requests
//  a little more gracefully

#import <Foundation/Foundation.h>

#import "RequestHandlerDelegate.h"
#import "NSMutableDictionary+IntegerKeys.h"


@interface RequestHandler : NSObject {
    id<RequestHandlerDelegate> _delegate;
    NSInteger _currentTag;
    NSMutableDictionary *_connectionData;
    NSMutableDictionary *_connections; // For sanity in dealloc
}

// Initializer
-(id)initWithDelegate:(id<RequestHandlerDelegate>)requestDelegate;

// Starts processing a connection, returns a tag
-(NSInteger)startConnection:(NSURLRequest*)newRequest;

-(void)cancelAllRequests;

@property (nonatomic, assign) id<RequestHandlerDelegate>delegate;
@end
