//
//  HospitalGroupEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/19.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalGroupEntity : NSObject

@property (nonatomic,strong)NSString   *hospitalId;
@property (nonatomic,strong)NSString   *hospitalAddress;
@property (nonatomic,strong)NSString   *hospitalName;
@property (nonatomic,strong)NSArray    *appointList;

+ (NSArray *)parseHospitalGroupListWithJson:(id)json;

@end
