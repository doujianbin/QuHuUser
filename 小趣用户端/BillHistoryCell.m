//
//  BillHistoryCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillHistoryCell.h"

@interface BillHistoryCell ()

@property (nonatomic, weak)UIView *billHistoryView;

@property (nonatomic, weak)UIView *lineView;

@property (nonatomic, weak)UILabel *chargeLabel;

@property (nonatomic, weak)UILabel *dateLabel;

@property (nonatomic, weak)UIButton *selecteButton;

@property (nonatomic, copy)NSString *billId;

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
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setImage:[UIImage imageNamed:@"diangray"] forState:UIControlStateNormal];
        selectButton.userInteractionEnabled = NO;
        [selectButton setImage:[UIImage imageNamed:@"dianred"] forState:UIControlStateSelected];
        selectButton.adjustsImageWhenHighlighted = NO;
        [billHistoryView addSubview:selectButton];
        
        self.selecteButton = selectButton;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR(219, 220, 221, 1);
        [billHistoryView addSubview:lineView];
        self.lineView = lineView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:billHistoryView];
        
    }
    return self;
}

- (void)setHistoryBillInfo:(HistoryBillModel *)historyBillInfo {
    _historyBillInfo = historyBillInfo;
    
    NSString *time = [historyBillInfo.create_time substringToIndex:historyBillInfo.create_time.length - 3];
    self.dateLabel.text = time;
    
    self.selecteButton.selected = historyBillInfo.selected;
    
    self.billId = historyBillInfo.billId;
    
    NSString *priceString = [NSString stringWithFormat:@"专业陪诊%.2f元", historyBillInfo.price];
    
    NSMutableAttributedString *chargeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    
    NSRange prefRange = [priceString rangeOfString:@"专业陪诊"];
    NSRange suffixRange = NSMakeRange(prefRange.length, priceString.length-prefRange.length-prefRange.location);
    [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(74, 74, 74, 1) range:prefRange];
    [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:suffixRange];
    self.chargeLabel.attributedText = chargeString;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.billHistoryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75);
    
    self.chargeLabel.frame = CGRectMake(58, 12.5, 100, 23);
    
    self.dateLabel.frame = CGRectMake(58, 36.5, 171, 23);
    
    self.selecteButton.frame = CGRectMake(18.5, 26, 23, 23);
    
    self.lineView.frame = CGRectMake(0, 74.5,[UIScreen mainScreen].bounds.size.width, 0.5);
}

@end
