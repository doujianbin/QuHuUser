//
//  LoginStorage.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/16.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "LoginStorage.h"

static NSString * const ISLOGIN = @"isLogin";
static NSString * const HttpHeader = @"httpHeader";
static NSString * const CommonOrderDic = @"commonOrderDic";
static NSString * const SpecialOrderDic = @"specialOrderDic";
static NSString * const PhoneNum = @"PhoneNum";
static NSString * const YanZhengMa = @"YanZhengMa";
static NSString *const firstEnter = @"isFirstEnter";

static NSString *const nickName = @"nickName";
static NSString *const photo = @"photo";
static NSString * const KeFuNum = @"KeFuNum";
static NSString * const PregnancyStatus = @"PregnancyStatus";
static NSString * const IsFirstMakeOrder = @"IsFirstMakeOrder";
static NSString * const Package = @"Package";     // 套餐  dic

@implementation LoginStorage

/**
 *  存/取  手机号
 */
+ (void)savePhoneNum:(NSString *)str{
    [UserDefaultsUtils saveValue:str forKey:PhoneNum];
}

+ (NSString *)GetPhoneNum
{
    return [UserDefaultsUtils valueWithKey:PhoneNum];
}

/**
 *  存/取  验证码
 */
+ (void)saveYanZhengMa:(NSString *)str{
    [UserDefaultsUtils saveValue:str forKey:YanZhengMa];
}

+ (NSString *)GetYanZhengMa
{
    return [UserDefaultsUtils valueWithKey:YanZhengMa];
}

/**
 *  登陆成功
 */
+ (void)saveIsLogin:(BOOL)loginStatus{
    [UserDefaultsUtils saveBoolValue:loginStatus withKey:ISLOGIN];
}
+ (BOOL)isLogin{
    return  [UserDefaultsUtils boolValueWithKey:ISLOGIN];
}

/**
 *  存/取  登陆成功返回的 的 HTTP header
 */
+ (void)saveHTTPHeader:(NSString *)str{
    [UserDefaultsUtils saveValue:str forKey:HttpHeader];
}

+ (NSString *)GetHTTPHeader
{
    return [UserDefaultsUtils valueWithKey:HttpHeader];
}
/**
 *  存/取  首页获得的普通陪诊套餐信息
 */
+ (void)saveCommonOrderDic:(NSDictionary *)dic{
    [UserDefaultsUtils saveValue:dic forKey:CommonOrderDic];
}
+ (NSDictionary *)GetCommonOrderDic{
    return [UserDefaultsUtils valueWithKey:CommonOrderDic];
}
/**
 *  存/取  首页获得的特殊陪诊套餐信息
 */
+ (void)saveSpecialOrderDic:(NSDictionary *)dic{
    [UserDefaultsUtils saveValue:dic forKey:SpecialOrderDic];
}
+ (NSDictionary *)GetSpecialrderDic{
    return [UserDefaultsUtils valueWithKey:SpecialOrderDic];
}

/**
 *  存/取  首页获得的套餐套餐信息
 */

+ (void)savePackageArr:(NSArray *)arr{
    [UserDefaultsUtils saveValue:arr forKey:Package];
}
+ (NSArray *)GetPackageArr{
    return [UserDefaultsUtils valueWithKey:Package];
}

+ (void)saveFirstEnterStatus:(BOOL)isFirstEnter{
    [UserDefaultsUtils saveBoolValue:isFirstEnter withKey:firstEnter];
}
+ (BOOL)isFirstEnter{
    return [UserDefaultsUtils boolValueWithKey:firstEnter];
}

+ (void)savenickName:(NSString *)dic{
    [UserDefaultsUtils saveValue:dic forKey:nickName];
}
+ (NSString *)GetnickName{
    return [UserDefaultsUtils valueWithKey:nickName];
}

+ (void)savephoto:(NSString *)dic{
    [UserDefaultsUtils saveValue:dic forKey:photo];
}
+ (NSString *)Getphoto{
    return [UserDefaultsUtils valueWithKey:photo];
}

+ (void)saveKefuPhoneNum:(NSString *)phonenum{
    [UserDefaultsUtils saveValue:phonenum forKey:KeFuNum];
}
+ (NSString *)phonenum{
    return [UserDefaultsUtils valueWithKey:KeFuNum];
}

+ (void)savePregnancyStatus:(NSString *)pregnancyStatus{
    [UserDefaultsUtils saveValue:pregnancyStatus forKey:PregnancyStatus];
}
+ (NSString *)PregnancyStatus{
    return [UserDefaultsUtils valueWithKey:PregnancyStatus];
}

+ (void)saveFirstMakeOrder:(BOOL)isFirstMakeOrder{
    [UserDefaultsUtils saveBoolValue:isFirstMakeOrder withKey:IsFirstMakeOrder];
}
+ (BOOL)isFirstMakeOrder{
    return [UserDefaultsUtils boolValueWithKey:IsFirstMakeOrder];
}


@end
