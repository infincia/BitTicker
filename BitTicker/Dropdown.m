/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import "Dropdown.h"
#import "StatusItemView.h"

@implementation Dropdown

@synthesize tickerValue = _tickerValue;



@synthesize high;
@synthesize low;
@synthesize vol;
@synthesize buy;
@synthesize sell;
@synthesize last;
@synthesize dropdownView;



- (id)init
{
    self = [super init];

	volumeFormatter = [[NSNumberFormatter alloc] init];
	volumeFormatter.numberStyle = NSNumberFormatterDecimalStyle;
	volumeFormatter.hasThousandSeparators = YES;

	currencyFormatter = [[NSNumberFormatter alloc] init];
	currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
	currencyFormatter.currencyCode = @"USD"; // TODO: Base on market currency
	currencyFormatter.thousandSeparator = @","; // TODO: Base on local seperator for currency
	currencyFormatter.alwaysShowsDecimalSeparator = YES;
	currencyFormatter.hasThousandSeparators = YES;
	currencyFormatter.minimumFractionDigits = 4; // TODO: Configurable
    return self;
}

-(void)awakeFromNib {
	NSLog(@"Awake from nib in dropdown");
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
	statusItemView = [[StatusItemView alloc] init];
	statusItemView.statusItem = _statusItem;
	[statusItemView setToolTip:NSLocalizedString(@"BitTicker", @"Status Item Tooltip")];
		
	[_statusItem setView:statusItemView];
		
	trayMenu = [[NSMenu alloc] initWithTitle:@"Ticker"];
	[statusItemView setMenu:trayMenu];
  	NSMenuItem *menuItem  = [[NSMenuItem alloc] init];
	[menuItem setView:self.dropdownView];
	[trayMenu addItem:menuItem];


	    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTicker:) name:@"MtGox-Ticker" object:nil];

}

-(void)didReceiveTicker:(NSNotification *)notification {
	//NSAssert([NSThread currentThread] != [NSThread mainThread],@"Running on main thread!");	
	NSLog(@"Dropdown got ticker");
	NSDictionary *ticker = [[notification object] objectForKey:@"ticker"];

	//dispatch_async(dispatch_get_main_queue(), ^{

		
	[self setHigh:[currencyFormatter stringFromNumber:[ticker objectForKey:@"high"]]];
	[self setLow:[currencyFormatter stringFromNumber:[ticker objectForKey:@"low"]]];
	[self setBuy:[currencyFormatter stringFromNumber:[ticker objectForKey:@"buy"]]];
	[self setSell:[currencyFormatter stringFromNumber:[ticker objectForKey:@"sell"]]];
	[self setLast:[currencyFormatter stringFromNumber:[ticker objectForKey:@"last"]]];
	[self setVol:[volumeFormatter stringFromNumber:[ticker objectForKey:@"vol"]]];	
	//});
    

}

@end
