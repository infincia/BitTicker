//
//  Trade.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/27/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Trade : NSObject {
    NSInteger   _tid;       // Trade ID
    NSNumber    *_price;    // Price in USD
    NSNumber    *_amount;   // Amount bought/sold in BTC
    NSDate      *_date;     // Time/date that trade was fulfilled
}

@property (nonatomic) NSInteger tid;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSDate *date;

@end
