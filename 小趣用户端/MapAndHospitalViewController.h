//
//  MapAndHospitalViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/6.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalInMapEntity.h"


@protocol MapAndHospitalControllerDegelate <NSObject>

- (void)didSelectedHospitalWithEntity:(HospitalInMapEntity *)hospitalEntity;

@end

@interface MapAndHospitalViewController : UIViewController


@property (nonatomic ,strong)NSString *enterFirstCityName;
@property (nonatomic )int currentCityServe;   // 所在城市是否开通服务
@property (nonatomic ,strong)NSString *sourceFrom;   //1：为首页 2：为下单页

@property (nonatomic ,retain)id<MapAndHospitalControllerDegelate>delegate;

@end
