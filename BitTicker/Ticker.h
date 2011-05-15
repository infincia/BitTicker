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

#import <Cocoa/Cocoa.h>
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
@class ASIFormDataRequest;

@interface Ticker : NSObject {
	NSString *currentError;
	NSString *apiAddress;
	ASIFormDataRequest *request;
	NSNumber *high;
    NSNumber *low;
    NSNumber *vol;
    NSNumber *buy;
    NSNumber *sell;
    NSNumber *last;
    NSNumber *outdated;
}

@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) NSString *currentError;
@property (nonatomic,retain) NSNumber *high;
@property (nonatomic,retain) NSNumber *low;
@property (nonatomic,retain) NSNumber *vol;
@property (nonatomic,retain) NSNumber *buy;
@property (nonatomic,retain) NSNumber *sell;
@property (nonatomic,retain) NSNumber *last;
@property (nonatomic,retain) NSNumber *outdated;

-(id) init;
-(void) getTickerData;

@end
