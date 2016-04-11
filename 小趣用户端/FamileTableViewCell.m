//
//  FamileTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "FamileTableViewCell.h"

@implementation FamileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_name = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 34, 18)];
        [self.contentView addSubview:self.lab_name];
        self.lab_name.font = [UIFont systemFontOfSize:16];
        self.lab_name.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        
        self.lab_sexAndphoneNum = [[UILabel alloc]initWithFrame:CGRectMake(73, 15, 150, 18)];
        [self.contentView addSubview:self.lab_sexAndphoneNum];
        self.lab_sexAndphoneNum.font = [UIFont systemFontOfSize:17];
        self.lab_sexAndphoneNum.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        
        self.lab_IDCard = [[UILabel alloc]initWithFrame:CGRectMake(20, 41, 300, 16.5)];
        [self.contentView addSubview:self.lab_IDCard];
        self.lab_IDCard.font = [UIFont systemFontOfSize:16];
        self.lab_IDCard.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        
        UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 71.5, SCREEN_WIDTH, 0.5)];
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
