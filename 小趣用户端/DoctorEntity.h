//
//  DoctorEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/18.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorEntity : NSObject

@property (nonatomic,strong) NSString   *doctorId;
@property (nonatomic,strong) NSString   *name;
@property (nonatomic,strong) NSString   *phoneNumber;
@property (nonatomic,strong) NSString   *headPortraint;
@property (nonatomic,strong) NSString   *hospitalName;
@property (nonatomic,strong) NSString   *jobTitle;
@property (nonatomic,strong) NSString   *deptName;

+ (NSArray *)parseDoctorListWithJson:(id)json;
+ (DoctorEntity *)parseDoctorEntityWithJson:(id)json;
@end
