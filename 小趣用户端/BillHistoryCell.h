//
//  BillHistoryCell.h
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryBillModel.h"

@class BillHistoryCell;
@protocol BillHistoryCellDelegate <NSObject>

- (void)billHistoryCell:(BillHistoryCell *)cell didSelected:(BOOL)isSelected;

@end

@interface BillHistoryCell : UITableViewCell

@property (nonatomic, assign) id<BillHistoryCellDelegate> delegate;

@property (nonatomic, strong) HistoryBillModel *historyBillInfo;


@end
