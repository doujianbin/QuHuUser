//
//  CommonOrderEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/22.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonOrderEntity : NSObject

@property (nonatomic ,strong)NSString *_id;           // 订单id
@property (nonatomic ,strong)NSString *orderNo;       // 订单编号
@property (nonatomic ,strong)NSString *createTime;    // 下单时间
@property (nonatomic ,strong)NSDictionary *hospital;  // 地址
@property (nonatomic ,strong)NSString *scheduleTime;  // 预约时间
@property (nonatomic ,strong)NSString *startTime;  // 陪诊开始时间
@property (nonatomic ,strong)NSDictionary *patient;   // 成员
@property (nonatomic ,strong)NSDictionary *nurse;     // 护士数据
@property (nonatomic ,assign)int orderType;           // 订单类型 （普通陪诊／特需陪诊）
@property (nonatomic ,assign)int couponType;          // 优惠卷类型
@property (nonatomic ,assign)CGFloat couponValue;         // 优惠卷额度
@property (nonatomic ,strong)NSString *totalAmount;   // 合计金额
@property (nonatomic ,strong)NSString *overtimeAmount; // 超时价格
@property (nonatomic ,assign)int orderStatus;  // 订单类型
@property (nonatomic ,assign)int payStatus;     // 支付状态
@property (nonatomic ,strong)NSString *remark;
@property (nonatomic ,assign)int stars;
@property (nonatomic ,strong)NSString *remarkDetail;  // 详情的评论
@property (nonatomic ,assign)int remarkStars;       // 详情的星级
@property (nonatomic ,strong)NSString *cancelReason;
@property (nonatomic ,strong)NSString *payAmount;   // 详情中的应付金额
@property (nonatomic ,strong)NSString *setAmount;   // 套餐金额金额
@property (nonatomic ,strong)NSString *discountAmount;   // 套餐优惠金额
+ (NSArray *)parseCommonOrderWithJson:(id)json;
+ (CommonOrderEntity *)parseCommonOrderListEntityWithJson:(id)json;

@end
