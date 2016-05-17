//
//  CouponsEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsEntity : NSObject

@property (nonatomic ,strong)NSString *discountDesc;  // 金额描述
@property (nonatomic ,strong)NSString *expireTimeDesc;    // 有效时间描述
@property (nonatomic ,assign)int couponsId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)int type;
@property (nonatomic ,assign)int useable;
@property (nonatomic ,strong)NSString *usageDesc;    // 限制条件


+ (NSArray *)parseCouponsListWithJson:(id)json;
+ (CouponsEntity *)parseCouponsListEntityWithJson:(id)json;


@end
