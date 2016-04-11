//
//  PatientDetailEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/16.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientDetailEntity : NSObject

@property (nonatomic ,strong)NSString *patientId;
@property (nonatomic ,strong)NSString *serviceTime;
@property (nonatomic ,strong)NSString *hospitalName;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *deptName;
@property (nonatomic ,strong)NSString *diagnosis;             // 诊断
@property (nonatomic ,strong)NSString *diseaseDescription;    // 病情描述
@property (nonatomic ,strong)NSArray *pics;

+ (PatientDetailEntity *)parsePatientDetailEntityWithJson:(id)json;

+ (NSArray *)parsePatientDetailEntityArrayWithJson:(id)json;

@end
