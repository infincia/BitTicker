//
//  NSMutableArray+Shift.m
//  BitTicker
//
//  Created by steve on 6/15/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSMutableArray+Shift.h"


@implementation NSMutableArray (ShiftExtension)
-(id)shift {
    if([self count] < 1) return nil;
    id obj = [[[self objectAtIndex:0] retain] autorelease];
    [self removeObjectAtIndex:0];
    return obj;
}
@end
