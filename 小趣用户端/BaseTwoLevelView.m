//
//  BaseTwoLevelView.m
//  juliye-iphone
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "BaseTwoLevelView.h"

@implementation BaseTwoLevelView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.headerTableView = [[HeaderTableView alloc]initWithFrame:CGRectMake(0, 0, 110, CGRectGetHeight(self.frame))];
        self.headerTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self.headerTableView.tableView setTableFooterView:[UIView new]];
        [self addSubview:self.headerTableView];
        
        self.rightTabelView = [[UITableView alloc] initWithFrame:CGRectMake(110, 0, CGRectGetWidth(self.frame) - 110, CGRectGetHeight(self.frame))];
        self.rightTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.rightTabelView];
    }
    
    return self;
}

@end
