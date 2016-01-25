//
//  OrderCenterTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OrderCenterTableViewCell.h"

@implementation OrderCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(7.5, 7.5, SCREEN_WIDTH - 15, 186)];
        [self addSubview:backView];
        backView.layer.cornerRadius = 3;
        backView.layer.masksToBounds = YES;
        backView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.06].CGColor;//shadowColor阴影颜色
        backView.layer.shadowOffset = CGSizeMake(-1.5,1.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        backView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        backView.layer.shadowRadius = 3;//阴影半径，默认3
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH - 15, 35)];
        [backView addSubview:img1];
        [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
        
        self.imgStatus = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        [backView addSubview:self.imgStatus];
        
        self.lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(37.5, 10, 100, 16.5)];
        [backView addSubview:self.lab_orderStatus];
        [self.lab_orderStatus setFont:[UIFont systemFontOfSize:12]];
        [self.lab_orderStatus setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        
        self.lab_timeStatus = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 92.5, 15, 70, 15)];
        [backView addSubview:self.lab_timeStatus];
        [self.lab_timeStatus setTextColor:[UIColor colorWithHexString:@"#C7CAD1"]];
        [self.lab_timeStatus setFont:[UIFont systemFontOfSize:12]];
        
        self.lab_doctorName = [[UILabel alloc]initWithFrame:CGRectMake(15, 51, 100, 19)];
        [backView addSubview:self.lab_doctorName];
        [self.lab_doctorName setTextColor:[UIColor colorWithHexString:@"#000000"]];
        self.lab_doctorName.alpha = 0.8;
        [self.lab_doctorName setFont:[UIFont systemFontOfSize:18]];
        
        self.lab_hospitalName = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 260,15)];
        [backView addSubview:self.lab_hospitalName];
        [self.lab_hospitalName setFont:[UIFont systemFontOfSize:15]];
        [self.lab_hospitalName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self.lab_hospitalName setAlpha:0.8];
        
        self.lab_orderType = [[UILabel alloc]initWithFrame:CGRectMake(15, 110, 260, 15)];
        [backView addSubview:self.lab_orderType];
        [self.lab_orderType setFont:[UIFont systemFontOfSize:15]];
        [self.lab_orderType setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self.lab_orderType setAlpha:0.8];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
