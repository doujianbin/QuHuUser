//
//  HeaderTableView.m
//  juliye-iphone
//
//  Created by lixiao on 15/2/4.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "HeaderTableView.h"

@interface HeaderTableView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HeaderTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self addSubview:self.tableView];
        
        self.headerLabel= [[InsetsLabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
        self.headerLabel.backgroundColor = [UIColor whiteColor];
//        self.headerLabel.text = [self.data objectAtIndex:0];
        self.headerLabel.font = [UIFont systemFontOfSize:14];
        self.headerLabel.insets = UIEdgeInsetsMake(0, 12, 0, -12);
        [self addSubview:self.headerLabel];
    }
    return self;
}

- (void)reloadData
{
    [self.tableView reloadData];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:headerTitleForForRowAtIndexPath:)]) {
        self.headerLabel.text = [self.dataSource tableView:self.tableView headerTitleForForRowAtIndexPath:self.indexPath];
        [self selectRowAtIndexPath:self.indexPath];
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)selectedIndexPath{
    if (self.indexPath.row == 0) {
        self.headerLabel.text = [self.dataSource tableView:self.tableView headerTitleForForRowAtIndexPath:self.indexPath];
        self.headerLabel.hidden = NO;
    }else{
        self.headerLabel.hidden = YES;
    }
    [self.tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView selectRowAtIndexPath:self.indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = [self.tableView rectForRowAtIndexPath:self.indexPath];
    if ((scrollView.contentOffset.y - rect.origin.y) >= 0) {
        self.headerLabel.text = [self.dataSource tableView:self.tableView headerTitleForForRowAtIndexPath:self.indexPath];
        self.headerLabel.hidden = NO;
    }else{
        self.headerLabel.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

//设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}
//每一行的内容为数组相应索引的值
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    if (indexPath.row == 0) {
        self.headerLabel.text = [self.dataSource tableView:self.tableView headerTitleForForRowAtIndexPath:self.indexPath];
        self.headerLabel.hidden = NO;
    }else{
        self.headerLabel.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
