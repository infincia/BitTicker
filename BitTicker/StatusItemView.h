//  Created by steve on 5/2/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSView <NSMenuDelegate> {
    NSStatusItem *statusItem;
    NSString *tickerValue;
    BOOL isMenuVisible;
}

@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) NSString *tickerValue;

@end