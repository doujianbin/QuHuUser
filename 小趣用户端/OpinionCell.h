//
//  OpinionCell.h
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpinionTextView;

@interface OpinionCell : UITableViewCell

@property (nonatomic, strong)OpinionTextView *opinionTextView;

@property (nonatomic, copy)NSString *opinionTextViewText;


@end
