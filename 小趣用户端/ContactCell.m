//
//  ContactCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

@property (nonatomic, weak)UIView *contactView;

@end

@implementation ContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contactView = [[UIView alloc]init];
        contactView.backgroundColor = [UIColor whiteColor];
        self.contactView = contactView;
        
        UITextField *contactTextField = [[UITextField alloc]init];
        contactTextField.placeholder = @"电话／邮箱／QQ";
        [contactTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [contactView addSubview:contactTextField];
        self.contactTextField = contactTextField;

        [self.contentView addSubview:contactView];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contactView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 57);
    
    self.contactTextField.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width, 57);
}

@end
