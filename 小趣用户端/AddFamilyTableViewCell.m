//
//  AddFamilyTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "AddFamilyTableViewCell.h"

@implementation AddFamilyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_left = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 50, 17.5)];
        [self.contentView addSubview:self.lab_left];
        self.lab_left.font = [UIFont systemFontOfSize:16];
        self.lab_left.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.lab_left.alpha = 0.6;
        
        UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 56.5, SCREEN_WIDTH, 0.5)];
        [self.contentView addSubview:img_heng];
        [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
