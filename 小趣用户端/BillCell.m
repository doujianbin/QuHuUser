//
//  BillCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillCell.h"

@interface BillCell ()

@property (nonatomic, weak)UIView *billView;

@property (nonatomic, weak)UIView *lineView;

@end

@implementation BillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        UIView *billView = [[UIView alloc]init];
        billView.backgroundColor = [UIColor whiteColor];
        self.billView = billView;
        
        UILabel *billLabel = [[UILabel alloc]init];
        billLabel.adjustsFontSizeToFitWidth = YES;
        billLabel.textColor = COLOR(74, 74, 74, 1);
        [billView addSubview:billLabel];
        self.billLabel = billLabel;
        
        UIView *lineView =[[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [billView addSubview:lineView];
        self.lineView = lineView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:billView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.billView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 57);
    
    self.billLabel.frame = CGRectMake(15, 16, 126, 25);
        
    self.lineView.frame = CGRectMake(0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
