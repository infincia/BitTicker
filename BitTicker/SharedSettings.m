//
//  SharedSettings.m
//
//  Copyright 2011 Stephen Oliver <mrsteveman1@gmail.com>. All rights reserved.
//

#import "SharedSettings.h"
#import "EMKeychainItem.h"

static SharedSettings *sharedSettingManager = nil;

@implementation SharedSettings

@dynamic username,password,selected_market;

- (id)init {
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	if ((self = [super init])) {

	}
	[autoreleasepool release];
	return self;
}

- (void) checkDefaults {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"]) {
		
	} else {
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
		[[NSUserDefaults standardUserDefaults] setObject:@"ChangeMe" forKey:@"username"];
		[[NSUserDefaults standardUserDefaults] setObject:@"MtGox" forKey:@"selected_market"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		if (!self.password) {
			self.password = @"ChangeMe";
		}
	}
}

- (NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (void)setUsername:(NSString *)newusername {
	[[NSUserDefaults standardUserDefaults] setObject:newusername forKey:@"username"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Set Username: %@",newusername);
}

- (NSString *)password {
	EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:@"BitTicker-MtGox" withUsername:self.username];
	return keychainItem.password;
}

- (void)setPassword:(NSString *)newpassword {
	EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:@"BitTicker-MtGox" withUsername:self.username];
	keychainItem.password = newpassword;
	NSLog(@"Set password: %@",newpassword);
}

- (NSString *)selected_market {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"selected_market"];
}

- (void)setSelected_market:(NSString *)newmarket {
	[[NSUserDefaults standardUserDefaults] setObject:newmarket forKey:@"selected_market"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Set Market: %@",newmarket);
}

+ (id)sharedSettingManager {
	@synchronized(self) {
		if(sharedSettingManager == nil)
			sharedSettingManager = [[super allocWithZone:NULL] init];
	}
	return sharedSettingManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	return [[self sharedSettingManager] retain];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (NSUInteger)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}


-(void)dealloc {
	[super dealloc];
}

@end

