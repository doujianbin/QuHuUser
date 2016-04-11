//
//  PatientDetailTableViewCell.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientListTotalView.h"
#import "PatientDetailEntity.h"
#import "PatientPictureView.h"

@interface PatientDetailTableViewCell : UITableViewCell

@property (nonatomic ,strong)UILabel *lb_timeAndHospital;
@property (nonatomic ,strong)PatientListTotalView *v_hospitalName;
@property (nonatomic ,strong)PatientListTotalView *v_doctorName;
@property (nonatomic ,strong)PatientListTotalView *v_department;
@property (nonatomic ,strong)PatientListTotalView *v_diagnosis;
@property (nonatomic ,strong)PatientListTotalView *v_diseaseDescription;
@property (nonatomic ,strong)PatientPictureView *v_picture;

- (void)contentCellVWithPatientDetailEntity:(PatientDetailEntity *)patientEntity;

@end
