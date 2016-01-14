//
//  PersonDataCell.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PersonDataCell.h"

@interface PersonDataCell ()

@property (nonatomic ,weak)UIView *personDataView;

@end

@implementation PersonDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *personDataView = [[UIView alloc]init];
        personDataView.backgroundColor = [UIColor whiteColor];
        self.personDataView = personDataView;
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleToFill;
        [personDataView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = COLOR(74, 74, 74, 1);
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [personDataView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *creditLabel = [[UILabel alloc]init];
        creditLabel.adjustsFontSizeToFitWidth = YES;
        [personDataView addSubview:creditLabel];
        self.creditLabel = creditLabel;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:personDataView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.personDataView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90);
    
    self.iconImageView.frame = CGRectMake(15, 15, 60, 60);
    
    self.nameLabel.frame = CGRectMake(90, 20.5, 90, 25);
    
    self.creditLabel.frame = CGRectMake(90, 50.5, 62, 18.5);
}

@end
