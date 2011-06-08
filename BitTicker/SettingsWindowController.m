//
//  SettingsWindowController.m
//  BitTicker
//
//  Created by Matt Stith on 6/5/11.
//  Copyright 2011 none. All rights reserved.
//

#import "SettingsWindowController.h"

#import "SettingsWindow.h"
#import "SharedSettings.h"

#import "BitcoinMarket.h"

@implementation SettingsWindowController


- (id)init {
    if (!(self=[super initWithWindowNibName:@"SettingsWindow"])) return self;
    sharedSettings = [SharedSettings sharedSettingManager];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    settingsWindow = (SettingsWindow*)self.window;
    
    NSTableView *table = settingsWindow.marketListTable;
    
    table.allowsMultipleSelection = NO;
    table.allowsColumnReordering = NO;
    table.allowsColumnResizing = NO;
    table.allowsEmptySelection = NO;
    table.allowsColumnSelection = NO;
    
    [table reloadData];
    
    NSIndexSet *firstMarket = [NSIndexSet indexSetWithIndex:0];
    [table selectRowIndexes:firstMarket byExtendingSelection:NO];
}
#pragma mark - Table view
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    MSLog(@"Number of rows: %i",eNumberOfMarkets);
    return eNumberOfMarkets;
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return [sharedSettings stringForMarket:rowIndex];
}
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    selectedMarket = [settingsWindow.marketListTable selectedRow];
    BOOL enabled = [sharedSettings isMarketEnabled:selectedMarket];
    NSString *username = [sharedSettings usernameForMarket:selectedMarket];
    NSString *password = [sharedSettings passwordForMarket:selectedMarket];
    NSString *apiKey = [sharedSettings apiKeyForMarket:selectedMarket];
	
    settingsWindow.enabledCheckbox.state = enabled? NSOnState : NSOffState;
    
    if (username == nil) username = @"";
    if (password == nil) password = @"";
	if (apiKey == nil) apiKey = @"";
	
    settingsWindow.usernameField.stringValue = username;
    settingsWindow.passwordField.stringValue = password;
    settingsWindow.apiKeyField.stringValue = apiKey;
	
    settingsWindow.marketLabel.stringValue = [sharedSettings stringForMarket:selectedMarket];
}
// Customize table, it's pretty static. User doesn't need to interact.
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return NO;
}
- (BOOL)tableView:(NSTableView *)tableView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex {
    return NO;
}
#pragma mark - Actions
-(IBAction)enabledDidChange:(id)sender {
    BOOL enabled = [sender state] == NSOnState;
    [sharedSettings setIsEnabled:enabled forMarket:selectedMarket];
}
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if ([control tag] == 0) {
		[sharedSettings setUsername:[fieldEditor string] forMarket:selectedMarket];
        MSLog(@"Username changed");
    } else if ([control tag] == 1) {
		[sharedSettings setPassword:[fieldEditor string] forMarket:selectedMarket];
        MSLog(@"Password changed");
    } else if ([control tag] == 2) {
        [sharedSettings setAPIKey:[fieldEditor string] forMarket:selectedMarket];
        MSLog(@"API key changed");
    }
    return YES;
}
@end
