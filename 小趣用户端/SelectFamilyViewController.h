//
//  SelectFamilyViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberEntity.h"

@protocol SelectFamilyViewControllerDelegate <NSObject>

- (void)didSelectedMemberWithEntity:(MemberEntity *)memberEntity;

@end
@interface SelectFamilyViewController : UIViewController

@property (nonatomic)BOOL FromVc;  //YES 是从个人中心 我的成员进入

@property (nonatomic ,retain)id<SelectFamilyViewControllerDelegate>delegate;

@end
