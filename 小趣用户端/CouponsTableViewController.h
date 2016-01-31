//
//  CouponsViewController.h
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponsTableViewControllerDegelate <NSObject>

- (void)didSelectedCouponsWithDic:(NSDictionary *)couponsDic;

@end

@interface CouponsTableViewController : UIViewController

@property (nonatomic ,retain)id<CouponsTableViewControllerDegelate>delegate;

@property (nonatomic )BOOL isFromOrder;

@end

