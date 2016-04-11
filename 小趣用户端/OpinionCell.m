//
//  OpinionCell.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OpinionCell.h"

#import "OpinionTextView.h"

@interface OpinionCell ()<UITextViewDelegate>

@property (nonatomic, weak)UIView *contactView;

@end
@implementation OpinionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contactView = [[UIView alloc]init];
        contactView.backgroundColor = [UIColor whiteColor];
        self.contactView = contactView;
        [self.contentView addSubview:self.contactView];
        
        OpinionTextView *opinionTextView = [[OpinionTextView alloc]init];
        opinionTextView.placeholder = @"请输入您的意见或者建议";
        self.opinionTextView = opinionTextView;
        opinionTextView.delegate = self;
        [opinionTextView setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [contactView addSubview:opinionTextView];
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    self.contactView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    self.opinionTextView.frame = CGRectMake(13, 0, [UIScreen mainScreen].bounds.size.width, 150);
}



- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"%ld",textView.text.length);
    self.opinionTextView.wordsLabel.text = [NSString stringWithFormat:@"还可输入%ld字",300 - textView.text.length];
    self.opinionTextViewText = textView.text;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString* resultText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    return (resultText.length <= 300);
}


@end
