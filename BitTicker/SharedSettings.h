//
//  SharedSettings.h
//
//  Copyright 2011 Stephen Oliver <mrsteveman1@gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSettings : NSObject {
	NSString *selectedMarket;
}
- (void) checkDefaults;
+ (id)sharedSettingManager;

-(BOOL)isMarketEnabled:(NSInteger)market;
-(void)setIsEnabled:(BOOL)enabled forMarket:(NSInteger)market;

-(NSString*)usernameForMarket:(NSInteger)market;
-(void)setUsername:(NSString*)username forMarket:(NSInteger)market;

-(NSString*)passwordForMarket:(NSInteger)market;
-(void)setPassword:(NSString*)password forMarket:(NSInteger)market;

-(NSString*)stringForMarket:(NSInteger)market;

@property (retain) NSString *selectedMarket;
@end
