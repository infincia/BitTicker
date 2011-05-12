//
//  StatusItemView.m
//  Mi-Fi Monitor for Mac
//
//  Created by steve on 10/25/10.
//  Copyright 2010 none. All rights reserved.
//

#import "StatusItemView.h"
#import <QuartzCore/QuartzCore.h>

#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3
#define StatusItemWidth 72

@implementation StatusItemView

@synthesize statusItem;

- (void)drawRect:(NSRect)rect {
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    NSPoint point = NSMakePoint(1, 1);
    NSMutableDictionary *font_attributes = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont fontWithName:@"LucidaGrande-Bold" size:16];
    NSColor *black = [NSColor blackColor];
    NSColor *white = [NSColor whiteColor];
    [font_attributes setObject:font forKey:NSFontAttributeName];
    NSString *tickerPretty = [NSString stringWithFormat:@"$%0.4f",[tickerValue floatValue]];
    CGSize expected = [tickerPretty sizeWithAttributes:font_attributes];
    CGRect newFrame = self.frame;
    newFrame.size.width = expected.width + 5;
    self.frame = newFrame;
    if (isMenuVisible) {
        [font_attributes setObject:white forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:font_attributes];
    }
    else {
        [font_attributes setObject:black forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:font_attributes];
    }   
    [font_attributes release];
}


- (id)initWithFrame:(NSRect)frame {
	CGRect newFrame = CGRectMake(0,0,70,20);
    self = [super initWithFrame:newFrame];
    if (self) {
        self.tickerValue = @"0.0000";
        statusItem = nil;
        isMenuVisible = NO;
        [statusItem setLength:84];
    }
    return self;
}

- (void)dealloc {
    [statusItem release];
    [tickerValue release];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)event {
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
    // Treat right-click just like left-click
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];    
    [self setNeedsDisplay:YES];
}

- (NSColor *)ForegroundColor {
    if (isMenuVisible) {
        return [NSColor whiteColor];
    }
    else {
        return [NSColor whiteColor];
    }    
}

- (void)setTickerValue:(NSString *)value {
    [value retain];
    [tickerValue release];
    tickerValue = value;
    [self setNeedsDisplay:YES];
}

- (NSString *)tickerValue {
    return tickerValue;
}

@end
