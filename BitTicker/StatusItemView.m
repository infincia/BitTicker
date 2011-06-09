/*
 BitTicker is Copyright 2011 Stephen Oliver
 http://github.com/mrsteveman1
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */

#import "StatusItemView.h"
#import <QuartzCore/QuartzCore.h>

#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3
#define StatusItemWidth 50
#define ColorFadeFramerate 30.0
#define ColorFadeDuration 1.0

@implementation StatusItemView

@synthesize statusItem, previousTickerValue, colorTimer;

- (void)drawRect:(NSRect)rect {
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    
    NSPoint point = NSMakePoint(1, 1);
    NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont fontWithName:@"LucidaGrande" size:16];
    
    
    NSColor *white = [NSColor whiteColor];
    [fontAttributes setObject:font forKey:NSFontAttributeName];
    
    NSString *tickerPretty = [NSString stringWithFormat:@"$%0.2f",[tickerValue floatValue]];
    CGSize expected = [tickerPretty sizeWithAttributes:fontAttributes];
    CGRect newFrame = self.frame;
    newFrame.size.width = expected.width + 5;
    self.frame = newFrame;
    // expexted.width might be a decimal, we don't want burry edges on our highlight.
    [statusItem setLength:(int)(expected.width+0.5)+StatusItemViewPaddingWidth];
    
    if (isMenuVisible) {
        [fontAttributes setObject:white forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:fontAttributes];
    }
    else {
        NSColor *foreground_color;
        if(isAnimating){
            NSTimeInterval duration = -1.0 * [lastUpdated timeIntervalSinceNow];
            double colorAlpha;
            
            if(duration >= ColorFadeDuration){
                [self.colorTimer invalidate];
                isAnimating = NO;
                colorAlpha = 0.0;
            } else {
                colorAlpha = 1.0 - (duration / ColorFadeDuration);
            }
            
            foreground_color = [[NSColor blackColor] blendedColorWithFraction:colorAlpha ofColor:flashColor];
        }
        else foreground_color = [NSColor blackColor];
        
        [fontAttributes setObject:foreground_color forKey:NSForegroundColorAttributeName];
        [tickerPretty drawAtPoint:point withAttributes:fontAttributes];
    }   
    
    [fontAttributes release];
}


- (id)initWithFrame:(NSRect)frame {
	CGRect newFrame = CGRectMake(0,0,StatusItemWidth,[[NSStatusBar systemStatusBar] thickness]);
    self = [super initWithFrame:newFrame];
    if (self) {
        firstTick = YES;
        self.previousTickerValue = [NSNumber numberWithInt:0];
        self.tickerValue = [NSNumber numberWithInt:0];
        flashColor = [[NSColor blackColor] retain];
        lastUpdated = [[NSDate date] retain];
        statusItem = nil;
        isMenuVisible = NO;
        isAnimating = NO;
        [statusItem setLength:StatusItemWidth];
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

- (void)updateFade {
    [self setNeedsDisplay:YES];
}

- (void)setTickerValue:(NSNumber *)value {
    
    [previousTickerValue release];
    previousTickerValue = tickerValue;
    
    [value retain];
    tickerValue = value;
    
    double current = [tickerValue doubleValue];
    double previous = [previousTickerValue doubleValue];
    BOOL animate_color = YES;
    if(firstTick){
        firstTick = NO;
        animate_color = NO;
    } else if(current > previous){
        [flashColor release];
        flashColor = [[NSColor greenColor] retain];
    } else if(current < previous){
        [flashColor release];
        flashColor = [[NSColor redColor] retain];
    } else {
        animate_color = NO;
    }
    
    if(animate_color){
        
        self.colorTimer = [[NSTimer scheduledTimerWithTimeInterval:(1.0/ColorFadeFramerate)
                                                       target:self
                                                     selector:@selector(updateFade)
                                                     userInfo:nil
                                                      repeats:YES] retain];
        
        [lastUpdated release];
        lastUpdated = [[NSDate date] retain];
        isAnimating = YES;
    }

    
    [self setNeedsDisplay:YES];
    

}

- (NSNumber *)tickerValue {
    return tickerValue;
}

@end
