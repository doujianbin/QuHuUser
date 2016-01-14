//
//  SelectDoctorTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SelectDoctorTableViewCell.h"

@implementation SelectDoctorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imgPic = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 61, 61)];
        [self.contentView addSubview:self.imgPic];
        self.imgPic.layer.cornerRadius = 3.0f;
        self.imgPic.layer.masksToBounds = YES;
        self.imgPic.layer.borderWidth = 0.5f;
        self.imgPic.layer.borderColor = [[UIColor colorWithHexString:@"#4A4A4A"] CGColor];
        
        self.lab_name = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, 51, 24)];
        [self.contentView addSubview:self.lab_name];
        [self.lab_name setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        self.lab_name.font = [UIFont systemFontOfSize:17];
        [self.lab_name setText:@"窦建斌"];
        
        self.lab_zhicheng = [[UILabel alloc]initWithFrame:CGRectMake(152, 19.5, 60, 15)];
        [self.contentView addSubview:self.lab_zhicheng];
        [self.lab_zhicheng setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        self.lab_zhicheng.font = [UIFont systemFontOfSize:11];
        self.lab_zhicheng.alpha = 0.6;
        [self.lab_zhicheng setText:@"院长"];
        
        self.lab_hospital = [[UILabel alloc]initWithFrame:CGRectMake(91, 41, SCREEN_WIDTH - 50 - 91 - 20, 16.5)];
        [self.contentView addSubview:self.lab_hospital];
        self.lab_hospital.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.lab_hospital.font = [UIFont systemFontOfSize:12];
        [self.lab_hospital setText:@"北京协和医院"];
        
        self.lab_keshi = [[UILabel alloc]initWithFrame:CGRectMake(91, 59.5, 100, 16.5)];
        [self.contentView addSubview:self.lab_keshi];
        self.lab_keshi.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.lab_keshi.font = [UIFont systemFontOfSize:12];
        self.lab_keshi.alpha = 0.6;
        [self.lab_keshi setText:@"妇产科"];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
