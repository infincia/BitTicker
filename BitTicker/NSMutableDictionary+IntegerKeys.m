//
//  NSMutableDictionary+IntegerKeys.m
//  Bitcoin Trader
//
//  Created by Matt Stith on 4/30/11.
//  Copyright 2011 Insomnia Addict. All rights reserved.
//

#import "NSMutableDictionary+IntegerKeys.h"


@implementation NSMutableDictionary (NSMutableDictionary_IntegerKeys)

-(void)setObject:(id)anObject forIntegerKey:(NSInteger)aKey {
    [self setObject:anObject forKey:[NSNumber numberWithInteger:aKey]];
}

-(id)objectForIntegerKey:(NSInteger)aKey {
    return [self objectForKey:[NSNumber numberWithInteger:aKey]];
}
-(void)removeObjectForInteger:(NSInteger)aKey {
    [self removeObjectForKey:[NSNumber numberWithInteger:aKey]];
}
@end
