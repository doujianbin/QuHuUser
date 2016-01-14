//
//  UITextField+ResignKeyboard.h
//  zlycare-iphone
//
//  Created by 洪聪 on 15/1/8.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ResignKeyboard)

- (void)setNormalInputAccessory;
- (void)setNormalInputAccessoryTarget:(id)target action:(SEL)action;

@end
