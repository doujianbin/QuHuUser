//
//  BaseTwoLevelView.h
//  juliye-iphone
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetsLabel.h"
#import "HeaderTableView.h"

@interface BaseTwoLevelView : UIView

@property(nonatomic,strong)InsetsLabel* headerLabel;
@property(nonatomic,strong)HeaderTableView* headerTableView;
@property(nonatomic,strong)UITableView* rightTabelView;

@end
