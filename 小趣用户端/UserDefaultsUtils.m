//
//  UserDefaultsUtils.m
//  ZLYDoc
//
//  Created by Ryan on 14-4-1.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "UserDefaultsUtils.h"

@implementation UserDefaultsUtils

+(void)saveValue:(id) value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(id)valueWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(void)print{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    NSLog(@"%@",dic);
}

+(void)saveObject:(id)object forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //将student类型变为NSData类型
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
}

+(id)objectWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
