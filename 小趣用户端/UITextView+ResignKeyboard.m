//
//  UITextView+ResignKeyboard.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/15.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "UITextView+ResignKeyboard.h"

@implementation UITextView (ResignKeyboard)

- (void)setNormalInputAccessory
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 5,SCREEN_WIDTH, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(hideKeyboard)];
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButton,doneButton,nil];
    [topView setItems:buttonsArray];
    [topView setBackgroundColor:[UIColor lightGrayColor]];
    [self setInputAccessoryView:topView];
}

- (void)setNormalInputAccessoryTarget:(id)target action:(SEL)action
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone  target:target action:action];
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButton,doneButton,nil];
    [topView setItems:buttonsArray];
    [topView setBackgroundColor:[UIColor lightGrayColor]];
    [self setInputAccessoryView:topView];
}

- (void)hideKeyboard{
    [self resignFirstResponder];
}

@end
