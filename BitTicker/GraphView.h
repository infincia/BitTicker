/*
 BitTicker is Copyright 2012 Stephen Oliver
 http://github.com/infincia
 
*/

#import <Foundation/Foundation.h>

#import "CorePlot.h"

#define TIMEFRAME_30MIN  100
#define TIMEFRAME_12HOUR 200
#define TIMEFRAME_24HOUR 300


@interface GraphView : NSView <CPTPlotDataSource> {

    NSArray *_graphSource;

    
    CPTXYGraph *_graph;
	CPTGraphHostingView *hostingView;
	CPTScatterPlot *dataSourceLinePlot;
	
	NSInteger timeframe;
	
}

-(IBAction)timeframeChanged:(id)sender;

@property (nonatomic) NSInteger timeframe;


@property (retain) NSArray *graphSource;
@property (nonatomic, retain) CPTXYGraph *graph;


@end
