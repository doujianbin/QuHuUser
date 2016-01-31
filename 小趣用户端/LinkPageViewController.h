//
//  LinkPageViewController.h
//  DouDouDemo
//
//  Created by lixiao on 15/10/9.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinkPageViewControllerDelegate <NSObject>

- (void)enterMainViewController;

@end

@interface LinkPageViewController : UIViewController
@property (nonatomic,assign)id<LinkPageViewControllerDelegate>delegate;
- (instancetype)initWithImageArray:(NSArray *)arr_images;
@end
