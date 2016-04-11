//
//  PatientListTotalView.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientListTotalView.h"
#import "NSString+Size.h"

@implementation PatientListTotalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.img_detail = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13.5, 16, 16)];
        [self addSubview:self.img_detail];
        
        self.lb_detail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_detail.frame) + 11, 12, SCREEN_WIDTH - CGRectGetMaxX(self.img_detail.frame) - 22, 12)];
        [self addSubview:self.lb_detail];
        self.lb_detail.font = [UIFont systemFontOfSize:15];
        self.lb_detail.numberOfLines = 0;
        
        self.v_line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        [self addSubview:self.v_line];
        [self.v_line setBackgroundColor:[UIColor colorWithHexString:@"dbdcdd"]];
        
    }
    return self;
}

-(void)setLabelText:(NSString *)str withOrifinY:(CGFloat)originY{
    [self.lb_detail setText:str];
    CGFloat height = [str fittingLabelHeightWithWidth:self.lb_detail.frame.size.width andFontSize:self.lb_detail.font];
    [self.lb_detail setFrame:CGRectMake(CGRectGetMaxX(self.img_detail.frame) + 11, 12, SCREEN_WIDTH - CGRectGetMaxX(self.img_detail.frame) - 22, height)];
    [self setFrame:CGRectMake(0, originY, SCREEN_WIDTH, 12 * 2 + height + 0.5)];
    [self.v_line setFrame:CGRectMake(0, self.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
}

@end
