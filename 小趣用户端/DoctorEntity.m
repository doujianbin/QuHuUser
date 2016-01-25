//
//  DoctorEntity.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/18.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "DoctorEntity.h"

@implementation DoctorEntity

+ (NSArray *)parseDoctorListWithJson:(id)json {
    return [self parseObjectArrayWithKeyValues:json];
}

+ (DoctorEntity *)parseDoctorEntityWithJson:(id)json{
    return [self parseObjectWithKeyValues:json];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"_id" : @"id",
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
