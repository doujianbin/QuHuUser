//
//  HospitalTimeTableViewCell.m
//  小趣用户端
//
//  Created by lixiao on 16/1/20.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "HospitalTimeTableViewCell.h"

@implementation HospitalTimeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lb_number = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 16, 16)];
        [self.lb_number setTextAlignment:NSTextAlignmentCenter];
        [self.lb_number setFont:[UIFont systemFontOfSize:11]];
        [self.lb_number setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        [self.lb_number setTextColor:[UIColor colorWithHexString:@"#FFFFFFFF"]];
        [self addSubview:self.lb_number];
        
        self.lb_hospitalName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lb_number.frame) + 10, 13.5, 250, 22.5)];
        [self.lb_hospitalName setFont:[UIFont systemFontOfSize:16]];
        [self.lb_hospitalName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self addSubview:self.lb_hospitalName];
        
        self.lb_address = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lb_number.frame) + 10, CGRectGetMaxY(self.lb_hospitalName.frame) + 1.5, 300, 20)];
        [self.lb_address setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [self.lb_address setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.lb_address];
        
        UIView *v_line = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 0.5)];
        [v_line setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
        [self addSubview:v_line];
        
        
    }
    return self;
}

- (void)contentCellWithHospitalGroupEntity:(HospitalGroupEntity *)hospitalGroupEntity withIndex:(int)index{
    self.hospitalGroupEntity = hospitalGroupEntity;
    [self.lb_number setText:[NSString stringWithFormat:@"%d",index]];
        [self.lb_hospitalName setText:hospitalGroupEntity.hospitalName];
        [self.lb_address setText:hospitalGroupEntity.hospitalAddress];
//    [self.lb_hospitalName setText:@"上海市儿童医院（泸定路院区）"];
//    [self.lb_address setText:@"普陀区泸定路355号"];
    CGFloat width_button = 71.5;
    CGFloat height_button = 27.5;
    CGFloat height_up = 14.5;
    CGFloat height_center = 12.5;
    CGFloat width_left = 15;
    CGFloat width_center = (SCREEN_WIDTH - width_left*2 - 4*width_button)/3;
    
    for (int i = 0; i < hospitalGroupEntity.appointList.count; i ++) {
        AppointEntity *appointEntity = [hospitalGroupEntity.appointList objectAtIndex:i];
        UIButton *btn_time = [[UIButton alloc]initWithFrame:CGRectMake(width_left + width_button * (i % 4) + width_center * (i % 4),70 + height_up + i/4 * height_button + i/4 * height_center,width_button, height_button)];
        [btn_time.layer setBorderWidth:0.5];
        [btn_time setTitle:appointEntity.startTime forState:UIControlStateNormal];
        btn_time.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn_time.layer setCornerRadius:3];
        btn_time.tag = i;
        if ([appointEntity.status isEqualToString:@"0"]) {
            btn_time.alpha = 1;
            btn_time.titleLabel.attributedText = nil;
            [btn_time setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [btn_time.layer setBorderColor:[[UIColor colorWithHexString:@"#4A4A4A"] CGColor]];
            [btn_time setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn_time setEnabled:YES];
        }else if ([appointEntity.status isEqualToString:@"1"]){
            btn_time.titleLabel.attributedText = nil;
            [btn_time setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
            [btn_time.layer setBorderColor:[[UIColor colorWithHexString:@"#4A4A4A"] CGColor]];
            [btn_time setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn_time setEnabled:NO];
        }else if ([appointEntity.status isEqualToString:@"2"]){
            btn_time.alpha = 1;
            [btn_time setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
            [btn_time.layer setBorderColor:[[UIColor colorWithHexString:@"#E6E6E8"] CGColor]];
            [btn_time setTitleColor:[UIColor colorWithHexString:@"#E6E6E8"] forState:UIControlStateNormal];
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:btn_time.titleLabel.text attributes:attribtDic];
            btn_time.titleLabel.attributedText = attribtStr;
            [btn_time setEnabled:NO];
        }
        [btn_time addTarget:self action:@selector(addTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_time];
    }
}

- (void)addTimeAction:(UIButton *)btn_sender{
    AppointEntity *entity = [self.hospitalGroupEntity.appointList objectAtIndex:btn_sender.tag];
    [self.delegate didSelectedWithAppointEntity:entity withHospitalGroupEntity:self.hospitalGroupEntity];
}

@end
