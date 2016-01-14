//
//  HospitalTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "HospitalTableViewCell.h"

@implementation HospitalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.img_hospitalPic = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 76, 57)];
        [self.contentView addSubview:self.img_hospitalPic];
        [self.img_hospitalPic setImage:[UIImage imageNamed:@"Oval 50 + Oval-52 + Shape"]];
        
        self.lab_hospital = [[UILabel alloc]initWithFrame:CGRectMake(103.5, 15.5, 200, 18)];
        [self.contentView addSubview:self.lab_hospital];
        self.lab_hospital.font = [UIFont systemFontOfSize:17];
        self.lab_hospital.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [self.lab_hospital setText:@"上海市曙光医院"];
        
        self.lab_hospitalAddress = [[UILabel alloc]initWithFrame:CGRectMake(103.5, 41, 200, 14)];
        [self.contentView addSubview:self.lab_hospitalAddress];
        self.lab_hospitalAddress.font = [UIFont systemFontOfSize:12];
        self.lab_hospitalAddress.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        
        self.img_dingwei = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 67, 17.5, 8, 10.5)];
        [self.contentView addSubview:self.img_dingwei];
        [self.img_dingwei setImage:[UIImage imageNamed:@"Oval 56"]];
        
        self.lab_juli = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55.5, 14, 40, 17.5)];
        [self.contentView addSubview:self.lab_juli];
        self.lab_juli.font = [UIFont systemFontOfSize:12];
        self.lab_juli.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        
        UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 71.5, SCREEN_WIDTH, 0.5)];
        [self.contentView addSubview:img_heng];
        [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
