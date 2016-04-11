//
//  OpinionTextView.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OpinionTextView.h"

@interface OpinionTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel  *placeholderLabel ;

@end

@implementation OpinionTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;

        
        UITextField *wordsLabel = [[UITextField alloc]init];
        wordsLabel.textColor = COLOR(208, 208, 208, 1);
//        wordsLabel.adjustsFontSizeToFitWidth = YES;
        wordsLabel.enabled = NO;
        wordsLabel.font = [UIFont systemFontOfSize:12];
        wordsLabel.placeholder =@"还可输入300字";
        [self addSubview:wordsLabel];
                
        self.wordsLabel = wordsLabel;
        
        self.font = [UIFont systemFontOfSize:16];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    }
    return self;
}


-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

-(void)textViewChange:(NSNotification *)notification{
    self.placeholderLabel.hidden =  self.text.length > 0;
    
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, MAXFLOAT);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   
    dict[NSFontAttributeName] = self.font;
    
    CGSize  titleSize =  [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    self.placeholderLabel.frame = CGRectMake(5, 8, titleSize.width, titleSize.height);
    
    self.wordsLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 110.5, self.frame.size.height - 14.5, 87, 10.5);
    
}



@end
