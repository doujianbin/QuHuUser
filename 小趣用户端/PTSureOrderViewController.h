//
//  PTSureOrderViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTSureOrderViewController : UIViewController

@property (nonatomic ,strong)NSString *str_OrderId;
@property (nonatomic ,assign)int       orderFromType;   // 如果为2  则是从订单列表进入

@end
