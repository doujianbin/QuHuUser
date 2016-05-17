//
//  CouponsTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CouponsTableViewCell.h"

@implementation CouponsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F9"];
        self.img_backGround = [[UIImageView alloc]initWithFrame:CGRectMake(11, 14, SCREEN_WIDTH - 22, 122)];
        [self.contentView addSubview:self.img_backGround];
//        [self.img_backGround setImage:[UIImage imageNamed:@"折扣券"]];
        
        self.lab_couponsName = [[UILabel alloc]initWithFrame:CGRectMake(21, 22, 200, 18)];
        [self.img_backGround addSubview:self.lab_couponsName];
        [self.lab_couponsName setFont:[UIFont systemFontOfSize:18]];
        
        self.lab_expireTimeDesc = [[UILabel alloc]initWithFrame:CGRectMake(20, 49, 200, 13)];
        [self.img_backGround addSubview:self.lab_expireTimeDesc];
        [self.lab_expireTimeDesc setFont:[UIFont systemFontOfSize:13]];
        
        self.lab_value = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 158, 24, 120, 27)];
        [self.img_backGround addSubview:self.lab_value];
        self.lab_value.textAlignment = NSTextAlignmentRight;
        [self.lab_value setFont:[UIFont systemFontOfSize:27]];
        
        
        self.lab_type = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 105, 63, 63, 14)];
        [self.img_backGround addSubview:self.lab_type];
        [self.lab_type setTextAlignment:NSTextAlignmentRight];
        [self.lab_type setFont:[UIFont systemFontOfSize:14]];
        
        self.lab_usageDesc = [[UILabel alloc]initWithFrame:CGRectMake(20, 98, SCREEN_WIDTH - 22, 12)];
        [self.img_backGround addSubview:self.lab_usageDesc];
        [self.lab_usageDesc setTextColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        self.lab_usageDesc.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
