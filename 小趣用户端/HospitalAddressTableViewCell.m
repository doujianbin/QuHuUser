//
//  HospitalAddressTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "HospitalAddressTableViewCell.h"

@implementation HospitalAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_left = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 70)];
        [self.contentView addSubview:self.lab_left];
        [self.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        self.lab_left.font = [UIFont systemFontOfSize:16];
        self.lab_left.alpha = 0.6;
        
        self.lab_hospital = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 200, 13.5, 200, 22.5)];
        [self.lab_hospital setFont:[UIFont systemFontOfSize:16]];
        [self.lab_hospital setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self.lab_hospital setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.lab_hospital];
        
        self.lab_addressDetail = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 200, CGRectGetMaxY(self.lab_hospital.frame) + 1.5, 200, 20)];
        [self.lab_addressDetail setFont:[UIFont systemFontOfSize:14]];
        self.lab_addressDetail.alpha = 0.6;
        [self.lab_addressDetail setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self.lab_addressDetail setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.lab_addressDetail];
        
        UIImageView *iv_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, SCREEN_WIDTH, 0.5)];
        [iv_line setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
        [self.contentView addSubview:iv_line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
