//
//  PayViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/2/20.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonOrderEntity.h"

@interface PayViewController : UIViewController

@property (nonatomic ,strong)CommonOrderEntity *entity;
@property (nonatomic ,strong)NSString *str_OrderId;
@property (nonatomic ,strong)NSString *orderNo;
@property (nonatomic ,strong)NSString *totalAmount;
@end
