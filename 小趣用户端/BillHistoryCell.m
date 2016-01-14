//
//  BillHistoryCell.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillHistoryCell.h"

@interface BillHistoryCell ()

@property (nonatomic, weak)UIView *billHistoryView;

@property (nonatomic, weak)UIView *lineView;

@end

@implementation BillHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *billHistoryView = [[UIView alloc]init];
        billHistoryView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:billHistoryView];
        self.billHistoryView = billHistoryView;

        UILabel *chargeLabel = [[UILabel alloc]init];
        chargeLabel.adjustsFontSizeToFitWidth = YES;
        [billHistoryView addSubview:chargeLabel];
        self.chargeLabel = chargeLabel;
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.textColor = COLOR(219, 220, 221, 1);
        [billHistoryView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UIImageView *selecteImageView = [[UIImageView alloc]init];
        selecteImageView.contentMode = UIViewContentModeScaleToFill;
        [billHistoryView addSubview:selecteImageView];
        self.selecteImageView = selecteImageView;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [billHistoryView addSubview:lineView];
        self.lineView = lineView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:billHistoryView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.billHistoryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75);
    
    self.chargeLabel.frame = CGRectMake(58, 12.5, 100, 23);
    
    self.dateLabel.frame = CGRectMake(58, 36.5, 171, 23);
    
    self.selecteImageView.frame = CGRectMake(18.5, 26, 23, 23);
    
    self.lineView.frame = CGRectMake(0, 74.5,[UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
