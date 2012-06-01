/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import "GraphView.h"
#import "CorePlot.h"


@implementation GraphView
@synthesize graph = _graph;
@synthesize graphSource = _graphSource;
@synthesize timeframe;

-(IBAction)timeframeChanged:(id)sender {

	NSSegmentedControl *control = (NSSegmentedControl*)sender;
	
	if ([control isSelectedForSegment:0]) {
		
		self.timeframe = TIMEFRAME_30MIN;
	}
	else if  ([control isSelectedForSegment:1]) {
		
		self.timeframe = TIMEFRAME_12HOUR;
	}
	else if  ([control isSelectedForSegment:2]) {
		
		self.timeframe = TIMEFRAME_24HOUR;
	}
	else {
		// should never happen
		NSAssert(1 == 0,@"Got invalid timeframe from control");
	}
	[self configureTimeframe];
	
}

-(void)awakeFromNib {

	NSInteger tf = [[NSUserDefaults standardUserDefaults] integerForKey:@"timeframe"];
	if (!tf) {
		tf = TIMEFRAME_30MIN;
		[[NSUserDefaults standardUserDefaults] setInteger:tf forKey:@"timeframe"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	self.timeframe = tf;
	_graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [self.graph applyTheme:theme];
	
    self.graph.cornerRadius = 6.0f;
    
    self.graph.paddingLeft = 0.0f;
    self.graph.paddingTop = 0.0f;
    self.graph.paddingRight = 0.0f;
    self.graph.paddingBottom = 0.0f;
    
    
    //graph.plotAreaFrame.masksToBorder = YES;
	
    self.graph.plotAreaFrame.cornerRadius = 6.0f;
    self.graph.plotAreaFrame.paddingLeft = 45.0f;
    self.graph.plotAreaFrame.paddingRight = 12.0f;
	
    self.graph.plotAreaFrame.paddingTop = 15.0f;
    self.graph.plotAreaFrame.paddingBottom = 25.0f;
    
    //x axis line style
    CPTMutableLineStyle *xlineStyle = [CPTMutableLineStyle lineStyle];
    xlineStyle.lineColor = [CPTColor redColor];
    xlineStyle.lineWidth = 1.0f;
    
    //y axis line style
    CPTMutableLineStyle *ylineStyle = [CPTMutableLineStyle lineStyle];
    ylineStyle.lineColor = [CPTColor blueColor];
    ylineStyle.lineWidth = 1.0f;        
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    // Tick locations
	NSSet *majorTickLocations = [NSSet setWithObjects:[NSDecimalNumber zero],
                                 [NSDecimalNumber numberWithUnsignedInteger:15],
                                 nil];
	
    
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(5); 
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.majorTickLineStyle = xlineStyle;
    axisSet.xAxis.minorTickLineStyle = xlineStyle;
    axisSet.xAxis.axisLineStyle = xlineStyle;
    axisSet.xAxis.minorTickLength = 4.0f;
    axisSet.xAxis.majorTickLength = 10.0f;
    axisSet.xAxis.majorTickLocations = majorTickLocations;
    axisSet.xAxis.title = nil;
	
	
    // Text styles
	CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
	axisTitleTextStyle.fontName = @"Helvetica-Bold";
    axisTitleTextStyle.color = [CPTColor whiteColor];
	axisTitleTextStyle.fontSize = 12.0;
	
	
    axisSet.xAxis.titleTextStyle = axisTitleTextStyle;
	axisSet.xAxis.titleOffset = 2.0f;
    axisSet.xAxis.labelOffset = 0.0f;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;

    
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(5); 
    axisSet.yAxis.minorTicksPerInterval = 0;
    //axisSet.yAxis.majorTicksPerInterval = 1;
    axisSet.yAxis.majorTickLineStyle = ylineStyle;
    axisSet.yAxis.minorTickLineStyle = ylineStyle;
    axisSet.yAxis.axisLineStyle = ylineStyle;
    axisSet.yAxis.minorTickLength = 4.0f;
    axisSet.yAxis.majorTickLength = 10.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
    [formatter setMaximumFractionDigits:0];
    [formatter setPositiveSuffix:@"$"];
    axisSet.yAxis.labelFormatter = formatter;

    
    // Line plot with gradient fill
    dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    dataSourceLinePlot.identifier = @"Data Source Plot";
    CPTMutableLineStyle *graphlineStyle = [CPTMutableLineStyle lineStyle];
    graphlineStyle.lineColor = [CPTColor whiteColor];
    graphlineStyle.lineWidth = 1.0f;
    dataSourceLinePlot.dataLineStyle = graphlineStyle;
    
    CPTColor *areaColor = [CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.6];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor whiteColor]];
    areaGradient.angle = 90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromDouble(0.0);
    
    dataSourceLinePlot.dataSource = self;
    [self.graph addPlot:dataSourceLinePlot];


	hostingView = [[CPTGraphHostingView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];


    hostingView.hostedGraph = self.graph;
    
    [self addSubview:hostingView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGraph:) name:@"MtGox-Ticker" object:nil];
    
    //[graph reloadData];
	[self configureTimeframe];

}


- (void) updateGraph:(NSNotification *)notification {
    self.graphSource = [[notification object] objectForKey:@"history"];

            

	[self configureTimeframe];
}

-(void)configureTimeframe {
    dispatch_async(dispatch_get_main_queue(), ^{
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
		
		
		float width_max = 0.0f;
		float beginning = 0.0f;
		float total = 1440.0f;
		
		
		switch (self.timeframe) {
			case TIMEFRAME_30MIN:
				NSLog(@"Updating timeframe for 30 min");
				width_max = 30.0f;
				//axisSet.xAxis.title = @"30 Mins";
				break;
			case TIMEFRAME_12HOUR:
				NSLog(@"Updating timeframe for 12 hours");
				width_max = 1220.0f;
				//axisSet.xAxis.title = @"12 Hours";
				break;
			case TIMEFRAME_24HOUR:
				NSLog(@"Updating timeframe for 24 hours");
				width_max = 1440.0f;
				//axisSet.xAxis.title = @"24 Hours";
				break;
			default:
				NSLog(@"NO TITLE");
				break;
		}
		
		beginning = total - width_max;
		NSArray *sortedArray = [self.graphSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSDictionary *one = (NSDictionary*)obj1;
			NSDictionary *two = (NSDictionary*)obj2;
			return [[one objectForKey:@"high"] compare:[two objectForKey:@"high"]];
		}];
		NSDictionary *highpoint = [sortedArray lastObject];
		NSInteger highestPrice = [[highpoint objectForKey:@"high"] intValue];
		//NSLog(@"Highest so far: %lu",highestRate);
            
		// Tick locations
		NSSet *majorTickLocations = [NSSet setWithObjects:[NSDecimalNumber zero],
                                 [NSDecimalNumber numberWithFloat:width_max],
                                 nil];
		
		axisSet.xAxis.majorTickLocations = majorTickLocations;
		
		
		
		axisSet.yAxis.majorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:0.0], [NSDecimalNumber numberWithInteger:highestPrice],[NSDecimalNumber numberWithInteger:highestPrice + 3],nil];
		
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(beginning) 
														length:CPTDecimalFromFloat(width_max)];
		
		plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0)
														length:CPTDecimalFromUnsignedInteger(highestPrice + 3)];
															
		NSLog(@"Beginning: %f, Max: %f",beginning, width_max);
		[self.graph reloadData];
	});
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	NSLog(@"Count: %ld",self.graphSource.count);
	return self.graphSource.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSDictionary *ticker = [self.graphSource objectAtIndex:index];
	
	double val = [[ticker objectForKey:@"last"] doubleValue];
	double time = 1440 - index;
	
	//NSLog(@"Graphing price: %f at %f",val,time);
	if( fieldEnum == CPTScatterPlotFieldX ) { 
		return [NSNumber numberWithDouble:time];
	}
	else { 
		return [NSNumber numberWithDouble:val];
	}
}


#pragma mark - View lifecycle


#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
#endif

@end
