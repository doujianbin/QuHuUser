//
//  OrderCenterTableViewCell.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCenterTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *lab_orderStatus;
@property (nonatomic, strong)UIImageView *imgStatus;
@property (nonatomic, strong)UILabel *lab_timeStatus;
@property (nonatomic, strong)UILabel *lab_name;
@property (nonatomic, strong)UILabel *lab_hospitalName;
@property (nonatomic, strong)UILabel *lab_orderType;
@property (nonatomic, strong)UILabel *lab_doctorName;
@property (nonatomic, strong)UIButton *btnAction;


@end
