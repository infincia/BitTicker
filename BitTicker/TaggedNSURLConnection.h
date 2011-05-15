//
//  TaggedNSUrlConnection.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//
//  NSURLConnection with an integer tag, for easier identification

#import <Foundation/Foundation.h>


@interface TaggedNSURLConnection : NSURLConnection {
    NSInteger _tag;
}
@property (nonatomic) NSInteger tag;
@end
