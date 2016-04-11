//
//  MemberEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberEntity : NSObject

@property (nonatomic ,retain)NSString *userName;
@property (nonatomic ,retain)NSString *phoneNumber;
@property (nonatomic ,retain)NSString *age;
@property (nonatomic ,retain)NSString *sex;
@property (nonatomic ,retain)NSString *idNo;
@property (nonatomic ,retain)NSString *zhurenID;
@property (nonatomic ,retain)NSString *userId;  // 就诊人id
@property (nonatomic ,retain)NSString *relation;

+ (MemberEntity *)parseMemberEntityWithJson:(id)json;
@end
