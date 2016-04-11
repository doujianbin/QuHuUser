//
//  OrderStateTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/21.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OrderStateTableViewCell.h"

@implementation OrderStateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_1 = [[UILabel alloc]init];
        [self.contentView addSubview:self.lab_1];
        [self.lab_1 setFrame:CGRectMake(0, 0, 40, 15)];
        [self.lab_1 setCenter:CGPointMake(39, 20)];
        [self.lab_1 setText:@"待接单"];
//        [self.lab_1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
        [self.lab_1 setFont:[UIFont systemFontOfSize:13]];
        [self.lab_1 setTextAlignment:NSTextAlignmentCenter];
        
        self.lab_2 = [[UILabel alloc]init];
        [self.contentView addSubview:self.lab_2];
        [self.lab_2 setFrame:CGRectMake(0, 0, 40, 15)];
        [self.lab_2 setCenter:CGPointMake((SCREEN_WIDTH - 70) / 3 + 36, 20)];
        [self.lab_2 setText:@"待陪诊"];
//        [self.lab_2 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
        [self.lab_2 setFont:[UIFont systemFontOfSize:13]];
        [self.lab_2 setTextAlignment:NSTextAlignmentCenter];
        
        self.lab_3 = [[UILabel alloc]init];
        [self.contentView addSubview:self.lab_3];
        [self.lab_3 setFrame:CGRectMake(0, 0, 40, 15)];
        [self.lab_3 setCenter:CGPointMake((SCREEN_WIDTH - 70) / 3 * 2 + 33, 20)];
        [self.lab_3 setText:@"陪诊中"];
//        [self.lab_3 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
        [self.lab_3 setFont:[UIFont systemFontOfSize:13]];
        [self.lab_3 setTextAlignment:NSTextAlignmentCenter];
        
        self.lab_4 = [[UILabel alloc]init];
        [self.contentView addSubview:self.lab_4];
        [self.lab_4 setFrame:CGRectMake(0, 0, 40, 15)];
        [self.lab_4 setCenter:CGPointMake((SCREEN_WIDTH - 70) + 31, 20)];
        [self.lab_4 setText:@"待支付"];
//        [self.lab_4 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
        [self.lab_4 setFont:[UIFont systemFontOfSize:13]];
        [self.lab_4 setTextAlignment:NSTextAlignmentCenter];
        
        self.img_orderState = [[UIImageView alloc]initWithFrame:CGRectMake(35, 32, SCREEN_WIDTH - 70, 10)];
        [self.contentView addSubview:self.img_orderState];
//        [self.img_orderState setImage:[UIImage imageNamed:@"02-00等待护士接单－进度条@2x_03"]];
        
        UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 56.5, SCREEN_WIDTH, 0.5)];
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
