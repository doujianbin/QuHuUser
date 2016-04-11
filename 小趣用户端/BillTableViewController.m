//
//  BillTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillTableViewController.h"

#import "UIBarButtonItem+Extention.h"

#import "BillCell.h"

#import "BillHistoryTableViewController.h"
#import "BillRecordTableViewController.h"

@interface BillTableViewController ()

@property (nonatomic, strong)NSArray *billArray;

@end

@implementation BillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发票";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark cell设置相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.billArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[BillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.billLabel.text = self.billArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 57;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    headerView.backgroundColor = COLOR(245, 246, 245, 1);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        BillHistoryTableViewController *billHistoryTableViewController = [[BillHistoryTableViewController alloc]init];
        [self.navigationController pushViewController:billHistoryTableViewController animated:YES];
        
    }else {
        
        BillRecordTableViewController *billRecordTableViewController = [[BillRecordTableViewController alloc]init];
        [self.navigationController pushViewController:billRecordTableViewController animated:YES];
    }
}

#pragma mark 懒加载billLabel数据
- (NSArray *)billArray {

    if (!_billArray) {
        _billArray = [NSArray arrayWithObjects:@"按服务历史开票",@"开票历史", nil];
    }
    return _billArray;
}

@end
