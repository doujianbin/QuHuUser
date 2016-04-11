//
//  PuTongPZViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberEntity.h"

@interface PuTongPZViewController : UIViewController

@property (nonatomic ,retain)NSString *str_hospitalName;
@property (nonatomic ,retain)NSString *str_hospitalAddress;
@property (nonatomic ,retain)NSString *str_hospitalId;
@property (nonatomic,strong)MemberEntity *entity;
@end
