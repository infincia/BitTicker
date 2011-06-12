//
//  MainWindowController.h
//  BitTicker
//
//  Created by steve on 6/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SharedSettings;

@interface MainWindowController : NSWindowController <NSWindowDelegate,NSTableViewDelegate,NSTableViewDataSource> {
@private
	SharedSettings *sharedSettings;
	NSMutableDictionary *_viewDict;
    IBOutlet NSTableView *marketListTable;
    NSInteger selectedMarket;
	NSView *_mainView;
	IBOutlet NSView *_mtGoxPanel;
	IBOutlet NSView *_tradeHillPanel;
	IBOutlet NSView *_mainPanel;
	NSView *_currentPanel;
	IBOutlet NSViewController *panelController;
}

@property (retain) NSMutableDictionary *viewDict;

@property (retain) IBOutlet NSView *mainView;
@property (nonatomic,retain) NSTableView *marketListTable;
@property (retain) NSView *currentPanel;
@end
