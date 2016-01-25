//
//  HospitalTimeTableViewCell.h
//  小趣用户端
//
//  Created by lixiao on 16/1/20.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalGroupEntity.h"
#import "AppointEntity.h"
@protocol HospitalTimeTableViewCellDelegate <NSObject>

- (void)didSelectedWithAppointEntity:(AppointEntity *)appointEntity withHospitalGroupEntity:(HospitalGroupEntity *)hospitalGroupEntity;

@end

@interface HospitalTimeTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel   *lb_number;
@property (nonatomic,strong)UILabel   *lb_hospitalName;
@property (nonatomic,strong)UILabel   *lb_address;
@property (nonatomic,strong)NSMutableArray *arr_time;
@property (nonatomic,strong)HospitalGroupEntity *hospitalGroupEntity;
@property (nonatomic,assign)id<HospitalTimeTableViewCellDelegate>delegate;
- (void)contentCellWithHospitalGroupEntity:(HospitalGroupEntity *)hospitalGroupEntity withIndex:(int)index;

@end
