//
//  TXOrderViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorEntity.h"
#import "AppointEntity.h"
#import "HospitalGroupEntity.h"
@interface TXOrderViewController : UIViewController

@property (nonatomic,strong)DoctorEntity  *doctorEntity;
@property (nonatomic,strong)AppointEntity  *appointEntity;
@property (nonatomic,strong)HospitalGroupEntity *hospitalEntity;

@end
