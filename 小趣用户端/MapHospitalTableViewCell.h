//
//  MapHospitalTableViewCell.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/9.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalInMapEntity.h"

@interface MapHospitalTableViewCell : UITableViewCell

@property (nonatomic ,strong)UILabel *lab_hospitalName;
@property (nonatomic ,strong)UILabel *lab_hospitalAddress;
@property (nonatomic ,strong)UILabel *lab_distance;
@property (nonatomic ,strong)UILabel *lab_hospitalLevel;

- (void)contentCellWithEntity:(HospitalInMapEntity *)entity;

@end
