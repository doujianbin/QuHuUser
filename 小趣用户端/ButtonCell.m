//
//  ButtonCell.m
//  小趣用户端
//
//  Created by 刘伟 on 16/1/26.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setBackgroundColor:COLOR(250, 98, 98, 1)];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button = button;
        
        [self.contentView addSubview:button];
        
        self.contentView.backgroundColor = COLOR(245, 246, 247, 1);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {

    self.button.frame = CGRectMake(19.5, 0, [UIScreen mainScreen].bounds.size.width - 39, 44);
}

@end
