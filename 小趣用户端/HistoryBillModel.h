//
//  HistoryBillModel.h
//  小趣用户端
//
//  Created by 刘伟 on 16/1/30.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryBillModel : NSObject

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy)NSString *billId;


@end
