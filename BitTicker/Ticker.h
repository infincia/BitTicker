//  Created by steve on 5/2/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
@class ASIFormDataRequest;

@interface Ticker : NSObject {
	NSString *currentError;
	NSString *apiAddress;
	ASIFormDataRequest *request;
	NSString *high;
    NSString *low;
    NSString *vol;
    NSString *buy;
    NSString *sell;
    NSString *last;
    NSNumber *outdated;
}

@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) NSString *currentError;
@property (nonatomic,retain) NSString *high;
@property (nonatomic,retain) NSString *low;
@property (nonatomic,retain) NSString *vol;
@property (nonatomic,retain) NSString *buy;
@property (nonatomic,retain) NSString *sell;
@property (nonatomic,retain) NSString *last;
@property (nonatomic,retain) NSNumber *outdated;

-(id) init;
-(void) getTickerData;

@end
