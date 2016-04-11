//
//  NotCompleteTableViewCell.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/21.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotCompleteTableViewCell : UITableViewCell

@property (nonatomic ,strong)UILabel *lab_time;
@property (nonatomic ,strong)UILabel *lab_status;
@property (nonatomic ,strong)UILabel *lab_name;
@property (nonatomic ,strong)UILabel *lab_hospital;
@property (nonatomic ,strong)UILabel *lab_price;
@property (nonatomic ,strong)UIButton *btnAction;

@end
