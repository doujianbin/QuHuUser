//
//  PatientTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientTableViewCell.h"

@implementation PatientTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_username = [[UILabel alloc]initWithFrame:CGRectMake(15, 20.5, 200, 16)];
        [self.contentView addSubview:self.lab_username];
        [self.lab_username setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        self.lab_username.font = [UIFont systemFontOfSize:17];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 56.5, SCREEN_WIDTH, 0.5)];
        [self.contentView addSubview:img];
        [img setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdc"]];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
