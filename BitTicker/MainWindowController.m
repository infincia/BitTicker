//
//  MainWindowController.m
//  BitTicker
//
//  Created by steve on 6/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MainWindowController.h"

#import "SharedSettings.h"

#import "BitcoinMarket.h"
@implementation MainWindowController

@synthesize mainView = _mainView;

@synthesize currentPanel = _currentPanel;

@synthesize marketListTable;

@synthesize viewDict = _viewDict;

- (id)init {
    if (!(self=[super initWithWindowNibName:@"MainWindow"])) return self;
	sharedSettings = [SharedSettings sharedSettingManager];
	panelController = [[NSViewController alloc] initWithNibName:@"PanelController" bundle:nil];
	[NSBundle loadNibNamed:@"MtGoxPanel" owner:self];
	[NSBundle loadNibNamed:@"TradeHillPanel" owner:self];
	[NSBundle loadNibNamed:@"MainPanelView" owner:self];
	self.viewDict = [NSMutableDictionary dictionaryWithCapacity:10];
	[self.viewDict setObject:_mtGoxPanel forKey:[sharedSettings stringForMarket:0]];
	[self.viewDict setObject:_tradeHillPanel forKey:[sharedSettings stringForMarket:1]];
	NSLog(@"%@",self.viewDict);
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.marketListTable reloadData];
    NSIndexSet *firstMarket = [NSIndexSet indexSetWithIndex:0];
    [self.marketListTable selectRowIndexes:firstMarket byExtendingSelection:NO];
}

#pragma mark - Table view


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return eNumberOfMarkets;
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSString *rowString = [sharedSettings stringForMarket:rowIndex];
	return rowString;
	
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSString *rowString = [sharedSettings stringForMarket:rowIndex];
	NSColor *txtColor;
	if ([self.marketListTable selectedRow] == rowIndex) {
		txtColor = [NSColor whiteColor];
	}
	else {
		txtColor = [NSColor blackColor];
	}

	NSFont *txtFont = [NSFont boldSystemFontOfSize:14];
	NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys: txtFont, NSFontAttributeName, txtColor, NSForegroundColorAttributeName, nil];
	NSAttributedString *attrStr = [[[NSAttributedString alloc] initWithString:rowString attributes:txtDict] autorelease];
	[aCell setAttributedStringValue:attrStr];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    selectedMarket = [self.marketListTable selectedRow];
	NSString *string = [sharedSettings stringForMarket:selectedMarket];
	NSView *panel = [self.viewDict objectForKey:string];
	if (selectedMarket == -1) {
		NSLog(@"Load Main Panel: %@",_mainPanel);
		[self.mainView replaceSubview:self.currentPanel with:_mainPanel];
		self.currentPanel = _mainPanel;		
	}
	else {
		if (self.currentPanel) {
			NSLog(@"Replace: %@",self.currentPanel);
			[self.mainView replaceSubview:self.currentPanel with:panel];
			self.currentPanel = panel;
		}
		else {
			NSLog(@"New: %@",panel);
			[self.mainView addSubview:panel];
			self.currentPanel = panel;
		}
	}
}
// Customize table, it's pretty static. User doesn't need to interact.
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return NO;
}
- (BOOL)tableView:(NSTableView *)tableView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex {
    return NO;
}

#pragma mark - Actions

- (void)dealloc
{
    [super dealloc];
}

@end
