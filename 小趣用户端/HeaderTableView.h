//
//  HeaderTableView.h
//  juliye-iphone
//
//  Created by lixiao on 15/2/4.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetsLabel.h"

@protocol HeaderTableViewDataSource <NSObject,UITableViewDataSource>

- (NSString*)tableView:(UITableView *)tableView headerTitleForForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HeaderTableViewDelegate <NSObject,UITableViewDelegate>

@end

@interface HeaderTableView : UIView

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)InsetsLabel* headerLabel;
@property(nonatomic,strong)NSIndexPath* indexPath;
@property(nonatomic,assign)id<HeaderTableViewDelegate> delegate;
@property(nonatomic,assign)id<HeaderTableViewDataSource> dataSource;

- (void)reloadData;
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
