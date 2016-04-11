//
//  OrderListEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/25.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListEntity : NSObject

@property (nonatomic ,strong)NSString * _id;
@property (nonatomic ,assign)int orderType;
@property (nonatomic ,assign)int orderStatus;
@property (nonatomic ,assign)int payStatus;
@property (nonatomic ,strong)NSString *createTimeStr;
@property (nonatomic ,strong)NSString *hospitalName;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *patientName;
@property (nonatomic ,strong)NSString *scheduleTime;
@property (nonatomic ,strong)NSString *totalAmount;
@property (nonatomic ,strong)NSString *nursePhoneNumber;
@property (nonatomic ,strong)NSString *remark;
@property (nonatomic ,strong)NSString *orderNo;
@property (nonatomic        )int stars;

+ (NSArray *)parseOrderListWithJson:(id)json;
+ (OrderListEntity *)parseOrderListEntityWithJson:(id)json;


@end
