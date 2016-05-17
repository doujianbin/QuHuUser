//
//  HospitalInMapEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/6.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalInMapEntity : NSObject

@property (nonatomic ,strong)NSString *address;
@property (nonatomic ,strong)NSString *distance;
@property (nonatomic ,assign)int       hospitalId;
@property (nonatomic ,strong)NSString *latitude;
@property (nonatomic ,strong)NSString *longitude;
@property (nonatomic ,strong)NSString *level;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)int       type;

+ (HospitalInMapEntity *)parseHospitalInMapEntityWithJson:(id)json;

+ (NSArray *)parseHospitalInMapWithJson:(id)json;
@end
