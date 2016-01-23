//
//  DayButton.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/19.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "DayButton.h"

@implementation DayButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lb_day = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 32, 28)];
        [self.lb_day setTextColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        [self.lb_day setFont:[UIFont systemFontOfSize:15]];
        [self.lb_day setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lb_day];
        
        UIImage *im_data = [UIImage imageNamed:@"Oval 129"];
        self.iv_status = [[UIImageView alloc]initWithFrame:CGRectMake(32/2 - im_data.size.width/2, 32 - 3 - im_data.size.height, im_data.size.width, im_data.size.height)];
        [self.iv_status setImage:im_data];
        [self addSubview:self.iv_status];
        
        
    }
    return self;
}

@end
