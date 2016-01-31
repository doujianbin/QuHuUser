//
//  MakeBillCell.m
//  小趣用户端
//
//  Created by 刘伟 on 16/1/26.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MakeBillCell.h"

@interface MakeBillCell ()

@property (nonatomic, weak)UIView *bgView;

@property (nonatomic, weak)UIView *lineView;

@end
@implementation MakeBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        self.bgView = bgView;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = COLOR(150, 150, 150, 1);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UITextField *detailtextField = [[UITextField alloc]init];
        detailtextField.adjustsFontSizeToFitWidth = YES;
        detailtextField.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:detailtextField];
        self.detailtextField = detailtextField;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [bgView addSubview:lineView];
        self.lineView = lineView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:bgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 57);
    
    self.titleLabel.frame = CGRectMake(15, 16, 72, 25);
    
    self.detailtextField.frame = CGRectMake(100, 18, [UIScreen mainScreen].bounds.size.width - 118, 22.5);
    
    self.lineView.frame = CGRectMake(0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
