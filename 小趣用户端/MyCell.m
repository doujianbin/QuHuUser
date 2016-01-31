//
//  MyCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MyCell.h"

@interface MyCell ()

@property (nonatomic, weak)UIView *lineView;


@end

@implementation MyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleToFill;
        self.iconImageView = iconImageView;
        
        UILabel *personCenterLabel = [[UILabel alloc]init];
        personCenterLabel.adjustsFontSizeToFitWidth = YES;
        personCenterLabel.textColor = COLOR(74, 74, 74, 1);
        self.personCenterLabel = personCenterLabel;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 220, 1);
        self.lineView = lineView;
        
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:personCenterLabel];
        [self.contentView addSubview:lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(14.5, 16.5, 24, 24);

    
    self.personCenterLabel.frame = CGRectMake(53, 16.5, 68, 24);
    self.lineView.frame = CGRectMake(0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
