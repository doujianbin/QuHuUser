//
//  DoctorDetailTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "DoctorDetailTableViewCell.h"
#import "NSString+Size.h"
@implementation DoctorDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self onCreate];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self onCreate];
    }
    return self;
}

- (void)onCreate{
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    
    self.lab_cellImgPic = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 45, 45)];
    [self.contentView addSubview:self.lab_cellImgPic];
    [self.lab_cellImgPic setImage:[UIImage imageNamed:@"Oval 50 + Oval-52 + Shape"]];
    self.lab_cellName = [[UILabel alloc]initWithFrame:CGRectMake(70, 17.5, 34, 18)];
    [self.contentView addSubview:self.lab_cellName];
    self.lab_cellName.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    self.lab_cellName.font = [UIFont systemFontOfSize:17];
    
    self.lab_cellzhicheng = [[UILabel alloc]initWithFrame:CGRectMake(114, 22, 150, 11.5)];
    [self.contentView addSubview:self.lab_cellzhicheng];
    self.lab_cellzhicheng.font = [UIFont systemFontOfSize:11];
    self.lab_cellzhicheng.alpha = 0.6;
    self.lab_cellzhicheng.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    
    self.lab_cellyiyuankeshi = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 200, 12.5)];
    [self.contentView addSubview:self.lab_cellyiyuankeshi];
    self.lab_cellyiyuankeshi.font = [UIFont systemFontOfSize:11];
    self.lab_cellyiyuankeshi.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    
    UIImageView *iv_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, SCREEN_WIDTH, 0.5)];
    [iv_line setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    [self addSubview:iv_line];
    
}

- (void)contentDoctorDetailWithDoctorEntity:(DoctorEntity *)doctorEntity{
    [self.lab_cellImgPic sd_setImageWithURL:[NSURL URLWithString:doctorEntity.headPortraint] placeholderImage:nil];
    self.lab_cellName.text = doctorEntity.name;
    self.lab_cellyiyuankeshi.text = [NSString stringWithFormat:@"%@  %@",doctorEntity.hospitalName,doctorEntity.deptName];
    self.lab_cellzhicheng.text = doctorEntity.jobTitle;
    CGFloat width = [self.lab_cellName.text fittingLabelWidthWithHeight:self.lab_cellName.frame.size.height andFontSize:self.lab_cellName.font];
    [self.lab_cellName setFrame:CGRectMake(self.lab_cellName.frame.origin.x, self.lab_cellName.frame.origin.y, width, self.lab_cellName.frame.size.height)];
    [self.lab_cellzhicheng setFrame:CGRectMake(CGRectGetMaxX(self.lab_cellName.frame) + 10,self.lab_cellzhicheng.frame.origin.y ,self.lab_cellzhicheng.frame.size.width, self.lab_cellzhicheng.frame.size.height)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
