//
//  BitTickerAppDelegate.h
//  BitTicker
//
//  Created by steve on 5/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BitTickerAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
