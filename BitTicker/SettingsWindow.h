//
//  SettingsWindowController.h
//  BitTicker
//
//  Created by Matt Stith on 6/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SharedSettings;

@interface SettingsWindow : NSWindow {
    IBOutlet NSTableView *marketListTable;
    IBOutlet NSButton *enabledCheckbox;
    IBOutlet NSTextField *marketLabel;
    IBOutlet NSTextField *usernameField;
    IBOutlet NSSecureTextField *passwordField;
	IBOutlet NSTextField *apiKeyField;
    
@private
    
}


@property (nonatomic,retain) NSTableView *marketListTable;
@property (nonatomic,retain) NSButton *enabledCheckbox;
@property (nonatomic,retain) NSTextField *marketLabel;
@property (nonatomic,retain) NSTextField *usernameField;
@property (nonatomic,retain) NSSecureTextField *passwordField;
@property (nonatomic,retain) NSTextField *apiKeyField;

@end
