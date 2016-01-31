//
//  CharacterCell.m
//  小趣用户端
//
//  Created by 刘伟 on 16/1/26.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CharacterCell.h"

@interface CharacterCell ()

@property (nonatomic, weak)UIView *bgView;

@end
@implementation CharacterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = COLOR(245, 246, 247, 1);
        self.bgView = bgView;
        
        UILabel *characterLabel = [[UILabel alloc]init];
        characterLabel.textColor = COLOR(155, 155, 155, 1);
        characterLabel.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:characterLabel];
        self.characterLabel = characterLabel;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = COLOR(245, 246, 247, 1);
        
        [self.contentView addSubview:bgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 19);
    
    self.characterLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 95, 0, 190, 19);
}

@end
