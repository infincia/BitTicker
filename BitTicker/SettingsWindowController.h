//
//  SettingsWindowController.h
//  BitTicker
//
//  Created by Matt Stith on 6/5/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SettingsWindow;
@class SharedSettings;

@interface SettingsWindowController : NSWindowController <NSWindowDelegate,NSTableViewDelegate,NSTableViewDataSource> {
@private
    SharedSettings *sharedSettings;
    
    // Same as self.window, but typecasted
    SettingsWindow *settingsWindow;
    
    NSInteger selectedMarket;
    
}

-(IBAction)enabledDidChange:(id)sender;

@end
