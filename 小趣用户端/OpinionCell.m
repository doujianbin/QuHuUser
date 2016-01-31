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

@end
@implementation OpinionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        OpinionTextView *opinionTextView = [[OpinionTextView alloc]init];
        opinionTextView.placeholder = @"请输入您的意见或者建议";
        self.opinionTextView = opinionTextView;
        opinionTextView.delegate = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:opinionTextView];
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    self.opinionTextView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
}



- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"%ld",textView.text.length);
    self.opinionTextView.wordsLabel.text = [NSString stringWithFormat:@"还可输入%ld字",300 - textView.text.length];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString* resultText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    return (resultText.length <= 300);
}


@end
