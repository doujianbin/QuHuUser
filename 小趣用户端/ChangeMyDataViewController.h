//
//  ChangeMyDataViewController.h
//  小趣用户端
//
//  Created by 李禹 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeMyDataViewControllerDelegate <NSObject>

- (void)changeMyDataViewControllerDidChangeName:(NSString *)name;

@end

@interface ChangeMyDataViewController : UIViewController

@property (nonatomic,weak) id <changeMyDataViewControllerDelegate> delegate;

@end
