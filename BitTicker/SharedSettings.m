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
	if (!(self = [super init])) return self;
        
    [EMGenericKeychainItem setLogsErrors:YES];
	keychainItems = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(EMGenericKeychainItem*)keychainItemForService:(NSInteger)service {
    NSString *serviceString = [@"BitTicker-" stringByAppendingString:[self stringForMarket:service]];
    
    EMGenericKeychainItem *item = [keychainItems objectForKey:serviceString];
    
    if (!item) {
        // We don't have one cached, check if one exists for the username
        NSString *username = [self usernameForMarket:service];
        if (!username) {
            // Username isn't in defaults, obviously password isn't either.
            item = [EMGenericKeychainItem addGenericKeychainItemForService:serviceString withUsername:@"" password:@""];
        } else {
            item = [EMGenericKeychainItem genericKeychainItemForService:serviceString withUsername:username];
            
            if (!item) {
                // We still don't have it. Make a new one.
                item = [EMGenericKeychainItem addGenericKeychainItemForService:serviceString withUsername:username password:@""];
            }
        }
    }
    [keychainItems setObject:item forKey:serviceString];
    return item;
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
    
    // Check for old username/password in keychain
    EMGenericKeychainItem *keychainItem = [self keychainItemForService:market];
    
    // If there is one, we need to update it.
    if (keychainItem) {
        keychainItem.username = username;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:usernameKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)passwordForMarket:(NSInteger)market {
    EMGenericKeychainItem *keychainItem = [self keychainItemForService:market];
    return keychainItem.password;
}
-(void)setPassword:(NSString*)password forMarket:(NSInteger)market {
    EMGenericKeychainItem *keychainItem = [self keychainItemForService:market];
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
    [keychainItems release];
	[super dealloc];
}

@end

