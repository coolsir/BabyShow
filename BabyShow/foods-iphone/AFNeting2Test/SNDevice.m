//
//  SNDevice.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "SNDevice.h"
#import "UICKeyChainStore.h"

#define kAnimolServiceName @"jp.animol.Animol"
#define kAnimolDeviceIdentifier @"deviceIdentifier"
#define kAnimolDeviceSecret     @"deviceSecret"


@implementation SNDevice

//得到设备设置语言
+ (NSString *)lang
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return language;
}
//得到设备UniqueIdentifier
+ (void)setUniqueIdentifier:(NSString *)auid
{   
    if(auid == nil)
    {
#if !TARGET_IPHONE_SIMULATOR
        [UICKeyChainStore removeItemForKey:kAnimolDeviceIdentifier service:kAnimolServiceName];
#endif
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAnimolDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
#if !TARGET_IPHONE_SIMULATOR
        [UICKeyChainStore setString:auid forKey:kAnimolDeviceIdentifier service:kAnimolServiceName];
#endif
        [[NSUserDefaults standardUserDefaults] setObject:auid forKey:kAnimolDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)uniqueIdentifier
{
    NSString *auid = nil;
    
#if !TARGET_IPHONE_SIMULATOR
    // Keychainを探す
    auid = [UICKeyChainStore stringForKey:kAnimolDeviceIdentifier service:kAnimolServiceName];
#endif
    
    // NSUserDefaultsのBackupを探す
    if (auid == nil)
    {
#if !TARGET_IPHONE_SIMULATOR
        LOG(@"[ERROR] Could not find auid from keychain");
#endif
        auid = [[NSUserDefaults standardUserDefaults] stringForKey:kAnimolDeviceIdentifier];
    }
    
    // BackupがなければKeychainの値を保存しておく
    if (auid != nil
        && [[NSUserDefaults standardUserDefaults] stringForKey:kAnimolDeviceIdentifier] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:auid forKey:kAnimolDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return auid;
}

+ (void)setSecret:(NSString *)adsecret
{
    
    if(adsecret == nil)
    {
#if !TARGET_IPHONE_SIMULATOR
        [UICKeyChainStore removeItemForKey:kAnimolDeviceSecret service:kAnimolServiceName];
#endif
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAnimolDeviceSecret];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
#if !TARGET_IPHONE_SIMULATOR
        [UICKeyChainStore setString:adsecret forKey:kAnimolDeviceSecret service:kAnimolServiceName];
#endif
        [[NSUserDefaults standardUserDefaults] setObject:adsecret forKey:kAnimolDeviceSecret];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (NSString *)secret
{
    NSString *secret = nil;
    
#if !TARGET_IPHONE_SIMULATOR
    // Keychainを探す
    secret = [UICKeyChainStore stringForKey:kAnimolDeviceSecret service:kAnimolServiceName];
#endif
    
    // NSUserDefaultsのBackupを探す
    if (secret == nil)
    {
        secret = [[NSUserDefaults standardUserDefaults] objectForKey:kAnimolDeviceSecret];
    }
    
    // BackupがなければKeychainの値を保存しておく
    if (secret != nil
        && [[NSUserDefaults standardUserDefaults] stringForKey:kAnimolDeviceSecret] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:secret forKey:kAnimolDeviceSecret];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return secret;
}

+ (float)getFreeDiskspace
{
    float totalSpace = 0.0f;
    float totalFreeSpace = 0.0f;
    
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        
        LOG(@"Memory Capacity of %f MiB with %f MiB Free memory available.", ((totalSpace/1024.0f)/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f));
    }
    else
    {
        LOG(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalFreeSpace;
}

+ (NSString *)deviceType
{
    return [UIDevice currentDevice].model;
}

@end
