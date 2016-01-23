//
//  BillRecordTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillRecordTableViewController.h"

#import "BillRecordCell.h"

@implementation BillRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    BillRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BillRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        NSMutableAttributedString *chargeString = [[NSMutableAttributedString alloc]initWithString:@"专业陪诊199元"];
        [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(74, 74, 74, 1) range:NSMakeRange(0, 4)];
        [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:NSMakeRange(4, 4)];
        cell.chargeLabel.attributedText = chargeString;
        cell.dateLabel.text = @"12月28日 08:00－10:00";
        cell.billStateLabel.text = @"已开票";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = COLOR(245, 246, 247, 1);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

@end







