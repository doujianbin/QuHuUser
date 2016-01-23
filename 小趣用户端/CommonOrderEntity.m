//
//  CommonOrderEntity.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/22.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CommonOrderEntity.h"

@implementation CommonOrderEntity

+ (NSArray *)parseCommonOrderWithJson:(id)json {
    return [self parseObjectArrayWithKeyValues:json];
}

+ (CommonOrderEntity *)parseCommonOrderListEntityWithJson:(id)json{
    return [self parseObjectWithKeyValues:json];
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
