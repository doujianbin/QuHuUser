//
//  DayGroupEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/19.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayGroupEntity : NSObject

@property (nonatomic,strong)NSString   *dayTime;
@property (nonatomic,strong)NSString   *week;
@property (nonatomic,strong)NSString   *day;
@property (nonatomic,strong)NSArray    *hospitalGroup;

+ (NSArray *)parseDayGroupListWithJson:(id)json;

@end
