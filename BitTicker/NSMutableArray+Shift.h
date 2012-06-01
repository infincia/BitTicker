//
//  NSMutableArray+Shift.h
//  BitTicker
//
//  Created by steve on 6/15/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (ShiftExtension)
// returns the first element of self and removes it
-(id)shift;
@end