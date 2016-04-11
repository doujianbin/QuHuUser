//
//  UITextView+ResignKeyboard.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/15.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ResignKeyboard)

- (void)setNormalInputAccessory;
- (void)setNormalInputAccessoryTarget:(id)target action:(SEL)action;

@end
