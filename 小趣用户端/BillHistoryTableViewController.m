//
//  BillHistoryTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillHistoryTableViewController.h"

#import "BillHistoryCell.h"

@interface BillHistoryTableViewController ()

@property (nonatomic,weak)BillHistoryCell *cell;

@end

@implementation BillHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 84)/2,75 * 3 + 16 , 84, 20)];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"没有更多了～";
    [self.view addSubview:label];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    BillHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BillHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        NSMutableAttributedString *chargeString = [[NSMutableAttributedString alloc]initWithString:@"专业陪诊199元"];
        [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(74, 74, 74, 1) range:NSMakeRange(0, 4)];
        [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:NSMakeRange(4, 4)];
        cell.chargeLabel.attributedText = chargeString;
        cell.dateLabel.text = @"12月28日 08:00－10:00";
        cell.selecteImageView.image = [UIImage imageNamed:@"member"];
        self.cell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",self.cell.tag);
    if (self.cell.tag == 0) {
        self.cell.selecteImageView.image = [UIImage imageNamed:@"share"];
        self.cell.tag = 1;
    }else {
        self.cell.selecteImageView.image = [UIImage imageNamed:@"member"];
        self.cell.tag = 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
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






