//
//  OpinionCell.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OpinionCell.h"

#import "OpinionTextView.h"

@implementation OpinionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        OpinionTextView *opinionTextView = [[OpinionTextView alloc]init];
        opinionTextView.placeholder = @"请输入您的意见或者建议";
        self.opinionTextView = opinionTextView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:opinionTextView];
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    self.opinionTextView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
}

@end
