//
//  CompleteTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/21.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CompleteTableViewCell.h"

@implementation CompleteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
        UIView *v_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
        [self.contentView addSubview:v_back];
        [v_back setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        
        UIView *v_time = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29)];
        [v_back addSubview:v_time];
        [v_time setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        
        self.lab_time = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 250, 18)];
        [v_time addSubview:self.lab_time];
        [self.lab_time setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [self.lab_time setFont:[UIFont systemFontOfSize:17]];
        
        self.lab_status = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 7, 70, 18)];
        [v_time addSubview:self.lab_status];
        [self.lab_status setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [self.lab_status setFont:[UIFont systemFontOfSize:17]];
        [self.lab_status setTextAlignment:NSTextAlignmentRight];
        
        UIImageView *img_line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
        [v_back addSubview:img_line1];
        [img_line1 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
        
        self.lab_name = [[UILabel alloc]initWithFrame:CGRectMake(15, 47, 200, 18)];
        [v_back addSubview:self.lab_name];
        [self.lab_name setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [self.lab_name setFont:[UIFont systemFontOfSize:17]];
        
        self.lab_hospital = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lab_name.frame) + 8, SCREEN_WIDTH - 115, 18)];
        [v_back addSubview:self.lab_hospital];
        [self.lab_hospital setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [self.lab_hospital setFont:[UIFont systemFontOfSize:17]];
        

        self.lab_price = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 58, 100, 20)];
        [self.contentView addSubview:self.lab_price];
        [self.lab_price setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [self.lab_price setTextAlignment:NSTextAlignmentRight];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
