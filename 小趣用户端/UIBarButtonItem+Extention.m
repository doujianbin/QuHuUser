//
//  UIBarButtonItem+Extention.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "UIBarButtonItem+Extention.h"

@implementation UIBarButtonItem (Extention)

+(UIBarButtonItem *)barButtonitemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    button.bounds = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
