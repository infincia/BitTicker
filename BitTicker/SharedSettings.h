//
//  SharedSettings.h
//
//  Copyright 2011 Stephen Oliver <mrsteveman1@gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSettings : NSObject {
		
	//Settings
	NSString *username;
	NSString *password;
	NSString *selected_market;
}
- (void) checkDefaults;
+ (id)sharedSettingManager;
@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSString *selected_market;
@end
