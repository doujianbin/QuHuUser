//
//  PatientEntity.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientEntity.h"
#import <MJExtension/MJExtension.h>

@implementation PatientEntity
+ (NSArray *)parsePatientWithJson:(id)json {
    return [self parseObjectArrayWithKeyValues:json];
}

+ (PatientEntity *)parsePatientEntityWithJson:(id)json{
    return [self parseObjectWithKeyValues:json];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"patientId" : @"id",
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
