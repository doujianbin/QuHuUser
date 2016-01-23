//
//  UIBarButtonItem+Extention.h
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extention)

+(UIBarButtonItem *)barButtonitemWithNormalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

@end
