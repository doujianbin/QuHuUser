//
//  BillRecordCell.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillRecordCell.h"

@interface BillRecordCell ()

@property (nonatomic,weak)UIView *recordView;

@property (nonatomic,weak)UIView *lineView;

@end

@implementation BillRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *recordView = [[UIView alloc]init];
        recordView.backgroundColor = [UIColor whiteColor];
        self.recordView = recordView;
        
        UILabel *chargeLabel = [[UILabel alloc]init];
        chargeLabel.adjustsFontSizeToFitWidth = YES;
        [recordView addSubview:chargeLabel];
        self.chargeLabel = chargeLabel;
        
        UILabel *dateLabel =[[UILabel alloc]init];
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.textColor = COLOR(219, 220, 221, 1);
        [recordView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UILabel *billStateLabel = [[UILabel alloc]init];
        billStateLabel.textColor = COLOR(74, 74, 74, 1);
        billStateLabel.adjustsFontSizeToFitWidth = YES;
        [recordView addSubview:billStateLabel];
        self.billStateLabel = billStateLabel;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [recordView addSubview:lineView];
        self.lineView = lineView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:recordView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.recordView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75);
    
    self.chargeLabel.frame = CGRectMake(18.5, 12.5, 100, 25);
    
    self.dateLabel.frame = CGRectMake(18.5, 37.5, 171, 25);
    
    self.billStateLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 63, 12.5, 48, 22.5);
    
    self.lineView.frame = CGRectMake(0, 74.5, [UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
