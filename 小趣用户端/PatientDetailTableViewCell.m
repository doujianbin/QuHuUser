//
//  PatientDetailTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientDetailTableViewCell.h"
#import "NSString+Size.h"

@implementation PatientDetailTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lb_timeAndHospital = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, SCREEN_WIDTH - 20 - 30, 20)];
        self.lb_timeAndHospital.numberOfLines = 0;
        [self.contentView addSubview:self.lb_timeAndHospital];
        self.lb_timeAndHospital.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.lb_timeAndHospital.font = [UIFont systemFontOfSize:17];
        
        UIImageView *img_jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 26, 15, 8, 12)];
        [self.contentView addSubview:img_jiantou];
        [img_jiantou setImage:[UIImage imageNamed:@"jiantou"]];
        
        self.v_doctorName = [[PatientListTotalView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lb_timeAndHospital.frame), SCREEN_WIDTH, 44)];
        [self.v_doctorName.img_detail setImage:[UIImage imageNamed:@"1.3档案页@2x_03"]];
        [self.contentView addSubview:self.v_doctorName];
        
        self.v_department = [[PatientListTotalView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_doctorName.frame), SCREEN_WIDTH, 44)];
        [self.v_department.img_detail setImage:[UIImage imageNamed:@"1.3档案页@2x_06"]];
        [self.contentView addSubview:self.v_department];
        
        self.v_diagnosis = [[PatientListTotalView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_department.frame), SCREEN_WIDTH, 44)];
        [self.v_diagnosis.img_detail setImage:[UIImage imageNamed:@"1.3档案页@2x_08"]];
        [self.contentView addSubview:self.v_diagnosis];
        
        self.v_diseaseDescription = [[PatientListTotalView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_diagnosis.frame), SCREEN_WIDTH, 44)];
        [self.v_diseaseDescription.img_detail setImage:[UIImage imageNamed:@"1.3档案页@2x_10"]];
        [self.contentView addSubview:self.v_diseaseDescription];
        
        self.v_picture = [[PatientPictureView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_diseaseDescription.frame), SCREEN_WIDTH, 0)];
        [self addSubview:self.v_picture];
        
    }
    return self;
}

- (void)contentCellVWithPatientDetailEntity:(PatientDetailEntity *)patientEntity{
    NSString *time = [patientEntity.serviceTime substringToIndex:16];
    [self.lb_timeAndHospital setText:[NSString stringWithFormat:@"%@  %@",time, patientEntity.hospitalName]];
    CGFloat height = [self.lb_timeAndHospital.text fittingLabelHeightWithWidth:self.lb_timeAndHospital.frame.size.width andFontSize:self.lb_timeAndHospital.font];
    [self.lb_timeAndHospital setFrame:CGRectMake(15, 12, self.lb_timeAndHospital.frame.size.width,height)];
    NSString *str_doctorName = @"";
    if (patientEntity.doctorName.length) {
        str_doctorName = patientEntity.doctorName;
        [self.v_doctorName.lb_detail setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    }else{
        str_doctorName = @"医生";
        [self.v_doctorName.lb_detail setTextColor:[UIColor colorWithHexString:@"#929292"]];
        
    }
    [self.v_doctorName setLabelText:str_doctorName withOrifinY:CGRectGetMaxY(self.lb_timeAndHospital.frame) + 12];
    NSString *str_department = @"";
    if (patientEntity.deptName.length) {
        str_department = patientEntity.deptName;
        [self.v_department.lb_detail setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    }else{
        str_department = @"科室";
        [self.v_department.lb_detail setTextColor:[UIColor colorWithHexString:@"#929292"]];
        
    }
    [self.v_department setLabelText:str_department withOrifinY:CGRectGetMaxY(self.v_doctorName.frame)];
    NSString *str_diagnosis = @"";
    if (patientEntity.diagnosis.length) {
        str_diagnosis = patientEntity.diagnosis;
        [self.v_diagnosis.lb_detail setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    }else{
        str_diagnosis = @"诊断";
        [self.v_diagnosis.lb_detail setTextColor:[UIColor colorWithHexString:@"#929292"]];
        
    }
    [self.v_diagnosis setLabelText:str_diagnosis withOrifinY:CGRectGetMaxY(self.v_department.frame)];
    NSString *str_diseaseDescription = @"";
    if (patientEntity.diseaseDescription.length) {
        str_diseaseDescription = patientEntity.diseaseDescription;
        [self.v_diseaseDescription.lb_detail setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    }else{
        str_diseaseDescription = @"病情描述";
        [self.v_diseaseDescription.lb_detail setTextColor:[UIColor colorWithHexString:@"#929292"]];
        
    }
    [self.v_diseaseDescription setLabelText:str_diseaseDescription withOrifinY:CGRectGetMaxY(self.v_diagnosis.frame)];
    [self.v_picture loadCollectionViewWithPicturesArray:patientEntity.pics withOrifinY:CGRectGetMaxY(self.v_diseaseDescription.frame)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
