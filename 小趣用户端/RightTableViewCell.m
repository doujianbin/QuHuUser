//
//  RightTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_hospitalName = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 8.5, SCREEN_WIDTH - 30 - 100, 24)];
        [self.contentView addSubview:self.lab_hospitalName];
        self.lab_hospitalName.font = [UIFont systemFontOfSize:17];
        self.lab_hospitalName.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        
        self.lab_address = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 32, SCREEN_WIDTH - 30 - 100, 18.5)];
        [self.contentView addSubview:self.lab_address];
        self.lab_address.font = [UIFont systemFontOfSize:13];
        self.lab_address.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        
        UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, self.contentView.frame.size.width, 0.5)];
        [self.contentView addSubview:img_heng];
        [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#D8D8D8"]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
