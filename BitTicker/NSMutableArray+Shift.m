//
//  NSMutableArray+Shift.m
//  BitTicker
//
//  Created by Matt Stith on 5/14/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSMutableArray+Shift.h"


@implementation NSMutableArray (Shift)
-(id)shift {
    if([self count] < 1) return nil;
    id obj = [[[self objectAtIndex:0] retain] autorelease];
    [self removeObjectAtIndex:0];
    return obj;
}
@end
