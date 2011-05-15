//
//  NSMutableDictionary+IntegerKeys.h
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (NSMutableDictionary_IntegerKeys)
-(void)setObject:(id)anObject forIntegerKey:(NSInteger)aKey;
-(id)objectForIntegerKey:(NSInteger)aKey;
-(void)removeObjectForInteger:(NSInteger)aKey;
@end
