//
//  SettingCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()

@property (nonatomic,weak)UIView *backGroundView;

@property (nonatomic,weak)UIView *lineView;

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        
        UILabel *settingLabel = [[UILabel alloc]init];
        settingLabel.textColor = COLOR(74, 74, 74, 1);
        settingLabel.adjustsFontSizeToFitWidth = YES;
        [backgroundView addSubview:settingLabel];
        self.settingLabel = settingLabel;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [backgroundView addSubview:lineView];
        self.lineView = lineView;
                
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:backgroundView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backGroundView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 57);
    
    self.settingLabel.frame = CGRectMake(15, 16, 72, 25);
        
    self.lineView.frame = CGRectMake(0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5);
}


@end
