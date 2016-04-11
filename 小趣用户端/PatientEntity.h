//
//  PatientEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientEntity : NSObject

@property (nonatomic ,strong)NSString *userName;
@property (nonatomic ,strong)NSString *patientId;

+ (PatientEntity *)parsePatientEntityWithJson:(id)json;

@end
