//
//  TwoLevelViewController.h
//  juliye-iphone
//
//  Created by lixiao on 16/1/11.
//  Copyright © 2016年 zlycare. All rights reserved.
//
#import "TwoLevelViewController.h"

@protocol TwoLevelViewControllerDegelate <NSObject>

- (void)didSelectedHospitalWithEntity:(NSDictionary *)hospitalDic;

@end

@interface TwoLevelViewController : UIViewController

@property (nonatomic ,retain)id<TwoLevelViewControllerDegelate>delegate;

@end
