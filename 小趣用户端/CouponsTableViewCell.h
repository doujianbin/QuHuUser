//
//  CouponsTableViewCell.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *img_backGround;
@property (nonatomic ,strong)UILabel *lab_couponsName;
@property (nonatomic ,strong)UILabel *lab_expireTimeDesc;  // 有效时间
@property (nonatomic ,strong)UILabel *lab_usageDesc;  // 限制条件
@property (nonatomic ,strong)UILabel *lab_value;
@property (nonatomic ,strong)UILabel *lab_type;

- (void)contentCellWithEntity:(NSDictionary *)dic;

@end
