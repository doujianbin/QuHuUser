//
//  MemberEntity.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MemberEntity.h"
#import <MJExtension/MJExtension.h>

@implementation MemberEntity

+ (NSArray *)parseMemberWithJson:(id)json {
    return [self parseObjectArrayWithKeyValues:json];
}

+ (MemberEntity *)parseMemberEntityWithJson:(id)json{
    return [self parseObjectWithKeyValues:json];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userId" : @"id",
             };
}

+ (NSArray *)parseObjectArrayWithKeyValues:(id)json
{
    if([NSJSONSerialization isValidJSONObject:json]){
        
        NSArray * result = nil;
        @try {
            result = [self objectArrayWithKeyValuesArray:json];
        }
        @catch (NSException *exception) {
            
            return nil;
        }
        return result;
    }else{
        return [NSArray array];
    }
}

+ (id)parseObjectWithKeyValues:(NSDictionary *)keyValues
{
    id result = nil;
    @try {
        result = [self objectWithKeyValues:keyValues];
    }
    @catch (NSException *exception) {
        return nil;
    }
    return result;
}


@end
