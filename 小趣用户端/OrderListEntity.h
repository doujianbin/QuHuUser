//
//  OrderListEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/25.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListEntity : NSObject

@property (nonatomic ,assign)int orderType;
@property (nonatomic ,assign)int orderStatus;
@property (nonatomic ,assign)int payStatus;
@property (nonatomic ,strong)NSString *createTimeStr;
@property (nonatomic ,strong)NSString *hospitalName;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *patientName;

+ (NSArray *)parseOrderListWithJson:(id)json;
+ (OrderListEntity *)parseOrderListEntityWithJson:(id)json;


@end
