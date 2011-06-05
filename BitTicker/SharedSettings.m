//
//  SharedSettings.m
//
//  Copyright 2011 Stephen Oliver <mrsteveman1@gmail.com>. All rights reserved.
//

#import "SharedSettings.h"
#import "EMKeychainItem.h"

#import "BitcoinMarket.h"

static SharedSettings *sharedSettingManager = nil;

@implementation SharedSettings

- (id)init {
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	if ((self = [super init])) {

	}
	[autoreleasepool release];
	return self;
}


-(BOOL)isMarketEnabled:(NSInteger)market {
    NSString *enabledKey = [NSString stringWithFormat:@"%@-enabled",[self stringForMarket:market]];
    return [[NSUserDefaults standardUserDefaults] boolForKey:enabledKey];
}
-(void)setIsEnabled:(BOOL)enabled forMarket:(NSInteger)market {
    NSString *enabledKey = [NSString stringWithFormat:@"%@-enabled",[self stringForMarket:market]];
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:enabledKey];
}

-(NSString*)usernameForMarket:(NSInteger)market {
    NSString *usernameKey = [NSString stringWithFormat:@"%@-username",[self stringForMarket:market]];
    return [[NSUserDefaults standardUserDefaults] stringForKey:usernameKey];
}
-(void)setUsername:(NSString*)username forMarket:(NSInteger)market {
    NSString *usernameKey = [NSString stringWithFormat:@"%@-username",[self stringForMarket:market]];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:usernameKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)passwordForMarket:(NSInteger)market {
    NSString *username = [self usernameForMarket:market];
    NSString *passwordKey = [NSString stringWithFormat:@"BitTicker-%@",[self stringForMarket:market]];
    EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:passwordKey withUsername:username];
    MSLog(@"Returning password for username: %@",username);
	return keychainItem.password;
}
-(void)setPassword:(NSString*)password forMarket:(NSInteger)market {
    NSString *username = [self usernameForMarket:market];
    NSString *passwordKey = [NSString stringWithFormat:@"BitTicker-%@",[self stringForMarket:market]];
    MSLog(@"Setting password for username %@",username);
    EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:passwordKey withUsername:username];
	keychainItem.password = password;
}

-(NSString*)stringForMarket:(NSInteger)market {
    switch (market) {
        case eMarketMtGox:
            return @"MtGox";
            break;
        default:
            return @"Unknown";
            break;
    }
}

#pragma mark - Singleton jazz

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

