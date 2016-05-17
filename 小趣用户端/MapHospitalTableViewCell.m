//
//  MapHospitalTableViewCell.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/9.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MapHospitalTableViewCell.h"
#import "NSString+Size.h"
#define MaxWidth SCREEN_WIDTH * 0.6

@implementation MapHospitalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lab_hospitalName = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 0, 17)];
        [self.contentView addSubview:self.lab_hospitalName];
        self.lab_hospitalName.font = [UIFont systemFontOfSize:17];
        [self.lab_hospitalName setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
        
        self.lab_hospitalLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lab_hospitalName.frame) + 16, 15, 26, 14)];
        [self.contentView addSubview:self.lab_hospitalLevel];
        self.lab_hospitalLevel.layer.borderWidth = 1.0f;
        self.lab_hospitalLevel.layer.borderColor = [[UIColor colorWithHexString:@"#41C9B8"] CGColor];
        self.lab_hospitalLevel.layer.cornerRadius = 2.0f;
        self.lab_hospitalLevel.font = [UIFont systemFontOfSize:11];
        [self.lab_hospitalLevel setTextColor:[UIColor colorWithHexString:@"#41C9B8"]];
        [self.lab_hospitalLevel setTextAlignment:NSTextAlignmentCenter];
        
        self.lab_hospitalAddress = [[UILabel alloc]initWithFrame:CGRectMake(15, 38, SCREEN_WIDTH - 100, 14)];
        [self.contentView addSubview:self.lab_hospitalAddress];
        self.lab_hospitalAddress.font = [UIFont systemFontOfSize:14];
        [self.lab_hospitalAddress setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
        
        self.lab_distance = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 27, 70, 17)];
        [self.contentView addSubview:self.lab_distance];
        self.lab_distance.font = [UIFont systemFontOfSize:17];
        [self.lab_distance setTextAlignment:NSTextAlignmentRight];
        [self.lab_distance setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65.5, SCREEN_WIDTH, 0.5)];
        [self.contentView addSubview:img];
        [img setBackgroundColor:[UIColor colorWithHexString:@"#DBDBDB"]];
        
        
    }
    return self;
}


- (void)contentCellWithEntity:(HospitalInMapEntity *)entity{
    
    CGFloat nameWidth = [entity.name fittingLabelWidthWithHeight:17 andFontSize:[UIFont systemFontOfSize:17]];
    if (nameWidth < MaxWidth) {
        [self.lab_hospitalName setFrame:CGRectMake(15, 16, nameWidth, 17)];
    }else{
        [self.lab_hospitalName setFrame:CGRectMake(15, 16, MaxWidth, 17)];
    }

    [self.lab_hospitalLevel setFrame:CGRectMake(CGRectGetMaxX(self.lab_hospitalName.frame) + 12, 16, 26, 16)];
    self.lab_hospitalName.text = entity.name;
    [self.lab_hospitalLevel setText:entity.level];
    self.lab_hospitalAddress.text = entity.address;
    self.lab_distance.text = entity.distance;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
