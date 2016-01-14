//
//  CouponsCell.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CouponsCell.h"

@implementation CouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *couponImageView = [[UIImageView alloc]init];
        couponImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:couponImageView];
        self.couponImageView = couponImageView;
        
        UILabel *couponTypeLabel = [[UILabel alloc]init];
        couponTypeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:couponTypeLabel];
        self.couponTypeLabel = couponTypeLabel;
        
        UILabel *endTimeLabel = [[UILabel alloc]init];
        endTimeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:endTimeLabel];
        self.endTimeLabel = endTimeLabel;
        
        UILabel *chargeLabel = [[UILabel alloc]init];
        chargeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:chargeLabel];
        self.chargeLabel = chargeLabel;
        
        self.contentView.backgroundColor = COLOR(245, 246, 246, 1);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.couponImageView.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 150);
    
    self.chargeLabel.frame = CGRectMake(200, 10, 100, 20);
}

@end
