//
//  BillHistoryTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillHistoryTableViewController.h"

#import "BillHistoryCell.h"
#import "UIBarButtonItem+Extention.h"

#import "MakeBillTableViewController.h"
#import "HistoryBillModel.h"

@interface BillHistoryTableViewController ()<UITableViewDataSource,UITableViewDelegate, BillHistoryCellDelegate>

@property (nonatomic, weak)UIButton *totalSelectButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak)UITableView *tableView;

@end

@implementation BillHistoryTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 3; i++) {
            HistoryBillModel *model = [[HistoryBillModel alloc] init];
            model.create_time = [NSString stringWithFormat:@"2016-1-2%zd", i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"按开票历史";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    [self setupTableView];
    
    [self setupTotalPriceView];
    
//    [self makeNSURLRequest];
    
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    [self.view addSubview:tableView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
}

- (void)setupTotalPriceView {

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = COLOR(219, 220, 221, 1);
    [bgView addSubview:lineView];
    
    UIButton *totalSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    totalSelectButton.frame = CGRectMake(10, 10.5, 23, 23);
    [totalSelectButton setImage:[UIImage imageNamed:@"diangray"] forState:UIControlStateNormal];
    [totalSelectButton setImage:[UIImage imageNamed:@"dianred"] forState:UIControlStateSelected];
    totalSelectButton.adjustsImageWhenHighlighted = NO;
    [totalSelectButton addTarget:self action:@selector(totalSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:totalSelectButton];
    self.totalSelectButton = totalSelectButton;
    
    UILabel *totalSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(39.5, 13, 28, 20)];
    totalSelectLabel.text = @"全选";
    totalSelectLabel.textColor = COLOR(74, 74, 74, 1);
    totalSelectLabel.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:totalSelectLabel];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 14, 130, 16.5)];
    totalLabel.adjustsFontSizeToFitWidth = YES;
    totalLabel.text = @"合计：299元（满200元包邮）";
    [bgView addSubview:totalLabel];
    
    UIButton *makeBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    makeBillButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 100, 44);
    [makeBillButton setBackgroundColor:COLOR(250, 98, 98, 1)];
    [makeBillButton setTitle:@"开票" forState:UIControlStateNormal];
    [makeBillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeBillButton addTarget:self action:@selector(makeBillButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:makeBillButton];
    
    [self.view addSubview:bgView];
}

- (void)totalSelectButtonClick:(UIButton *)button {

    NSLog(@"totalSelectButtonClick");
    button.selected = !button.selected;
    
    for (HistoryBillModel *model in self.dataArray) {
        model.selected = button.selected;
    }
    [self.tableView reloadData];
}

- (void)makeBillButtonClick {

    MakeBillTableViewController *makeBillTableViewController = [[MakeBillTableViewController alloc]init];
    [self.navigationController pushViewController:makeBillTableViewController animated:YES];
}

// TODO: 字典转模型
- (void)makeNSURLRequest {

    AFNManager *manager = [AFNManager shareManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/invoice/getUserCanInvoiceRecords",Development];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
        self.dataArray = [responseDic objectForKey:@"data"];
        
        
        NSLog(@"~~~~~~success %@",responseDic);
        
        NSLog(@"*&&&&&&&&&&%ld",self.dataArray.count);
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        NSLog(@"####### fail %@",error);
    }];
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"QQQQQQQQQQQQQQQ%ld",indexPath.row);
    
    static NSString *cellId1 = @"cell1";

        BillHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[BillHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
    cell.delegate = self;
        
        HistoryBillModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        cell.historyBillInfo = model;
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    headerView.backgroundColor = COLOR(245, 246, 247, 1);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 75;
    }else {
        
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - BillHistoryCellDelegate
- (void)billHistoryCell:(BillHistoryCell *)cell didSelected:(BOOL)isSelected {
    NSLog(@"%s", __func__);
}

@end






