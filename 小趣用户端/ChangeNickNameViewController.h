//
//  ChangeNickNameViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/18.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeNickNameControllerDegelate <NSObject>

- (void)didSelectedNickNameWithStr:(NSString *)strNickName;

@end

@interface ChangeNickNameViewController : UIViewController

@property (nonatomic ,retain)id<ChangeNickNameControllerDegelate>delegate;

@property (nonatomic ,strong)NSString *nickName;
@end
