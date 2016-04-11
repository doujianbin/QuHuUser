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
#import "NSArray+Extension.h"
#import <MJRefresh/MJRefresh.h>
#import "Toast+UIView.h"

@interface BillHistoryTableViewController ()<UITableViewDataSource,UITableViewDelegate, BillHistoryCellDelegate>

@property (nonatomic, weak)UIButton *totalSelectButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong)NSMutableArray *billIdArray;

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, weak) UILabel *totalLabel;

@property (nonatomic, assign)CGFloat totalPrice;
@end

@implementation BillHistoryTableViewController


- (NSMutableArray *)billIdArray {

    if (_billIdArray == nil) {
        _billIdArray = [NSMutableArray array];
    }
    return _billIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNSURLRequest];
    
    self.title = @"按开票历史";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;

}

-(void)viewWillAppear:(BOOL)animated{
    [self makeNSURLRequest];
}

- (void)setupTableView {
    
    
    if (self.dataArray.count == 0) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:tableView];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(SCREEN_HEIGHT - 127)/2 - 80, 115, 127)];
        
        imageView.image = [UIImage imageNamed:@"nothingView"];
        
//        imageView.contentMode = UIViewContentModeCenter;
        
        tableView.backgroundColor = COLOR(245, 246, 247, 1);
        
        [tableView addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame) + 20 , SCREEN_WIDTH, 20)];
        [tableView addSubview:lab];
        lab.font = [UIFont boldSystemFontOfSize:16];
        lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setText:@"您还没有可开发票的订单哦～"];
        
    }else {
    
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120)];
        [self.view addSubview:tableView];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.tableView = tableView;
        
        [self setupTotalPriceView];
    }
    
    
}

- (void)setupTotalPriceView {

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 64, [UIScreen mainScreen].bounds.size.width, 44)];
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
    totalLabel.text = @"合计：0元（满200元包邮）";
    [bgView addSubview:totalLabel];
    self.totalLabel = totalLabel;
    
    UIButton *makeBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    makeBillButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 100, 44);
    [makeBillButton setBackgroundColor:COLOR(250, 98, 98, 1)];
    [makeBillButton setTitle:@"开票" forState:UIControlStateNormal];
    [makeBillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeBillButton addTarget:self action:@selector(makeBillButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:makeBillButton];
    
    [self.view addSubview:bgView];
}



- (void)makeBillButtonClick {

    if (self.totalPrice == 0) {
        [self.view makeToast:@"请选择发票" duration:1.0 position:@"center"];
    }else{
        
        MakeBillTableViewController *makeBillTableViewController = [[MakeBillTableViewController alloc]init];
        makeBillTableViewController.totalPrice = self.totalPrice;
        makeBillTableViewController.billIdArray = self.billIdArray;
        
        [self.navigationController pushViewController:makeBillTableViewController animated:YES];
    }
}

- (void)makeNSURLRequest {

    BeginActivity;
    AFNManager *manager = [AFNManager shareManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/invoice/getUserCanInvoiceRecords",Development];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
        EndActivity;
        self.dataArray = [responseDic objectForKey:@"data"];
        
        
        HistoryBillModel *model = nil;
        
        NSMutableArray *arrM = [NSMutableArray array];
//        self.billIdArray = [NSMutableArray array];
        
        for (NSDictionary *dict in self.dataArray) {
            
            model = [[HistoryBillModel alloc] init];
            model.create_time = [dict objectForKey:@"create_time"];
            model.billId = [dict objectForKey:@"id"];
            
            if (![dict objectForKey:@"pay_amount"]) {
                model.price = 0.0;
            }
            
            model.price = [[dict objectForKey:@"pay_amount"] floatValue];
            
            [arrM addObject:model];
            
            if (model.selected == YES) {
                
                [self.billIdArray addObject:[dict objectForKey:@"id"]];
                
                NSLog(@"%@",self.billIdArray);

            }
            
        }
        
        self.dataArray = [arrM copy];
        
        NSLog(@"%@",self.dataArray);
        
        NSLog(@"~~~~~~success %@",responseDic);
        
        NSLog(@"*&&&&&&&&&&%ld",self.dataArray.count);
        [self.tableView reloadData];
        
        if (self.dataArray.count != 0) {
            
            [self setupTotalPriceView];
        }
        
        if (self.dataArray.count == 0) {
            
            self.view.backgroundColor = [UIColor whiteColor];
            
        }else {
            
            self.view.backgroundColor = COLOR(245, 246, 247, 1);
        }
        
        [self setupTableView];
        
    } fail:^(NSError *error) {
        EndActivity;
        NetError;
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
    
    static NSString *cellId1 = @"cell1";

    BillHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
    if (cell == nil) {
        cell = [[BillHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
    }

    if (!cell.delegate) {
        cell.delegate = self;
    }

    HistoryBillModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    
    cell.historyBillInfo = model;
    
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryBillModel *billModel = [self.dataArray safeObjectAtIndex:indexPath.row];
    billModel.selected = !billModel.selected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
     self.totalPrice = 0;
    for (HistoryBillModel *historyBillModel in self.dataArray) {
        if (historyBillModel.selected == YES) {
            self.totalPrice += historyBillModel.price;
            if (![self.billIdArray containsObject:historyBillModel.billId]) {
                
                [self.billIdArray addObject:historyBillModel.billId];
            }
        }else{
            [self.billIdArray removeObject:historyBillModel.billId];
        }
    }
    NSLog(@"总价%.2f", self.totalPrice);
    self.totalLabel.text = [NSString stringWithFormat:@"合计：%.2f元（满200元包邮）", self.totalPrice];
}

- (void)totalSelectButtonClick:(UIButton *)button {
    
    NSLog(@"totalSelectButtonClick");
    button.selected = !button.selected;
    self.totalPrice = 0;
//    for (HistoryBillModel *model in self.dataArray) {
//        model.selected = button.selected;
//        if (model.selected == YES) {
//            
//            self.totalPrice += model.price;
//            
//            if (![self.billIdArray containsObject:model.billId]) {
//                
//                [self.billIdArray removeObject:model.billId];
//            }
//        }else {
//            [self.billIdArray addObject:model.billId];
//        
//        }
//    }
    
    for (HistoryBillModel *historyBillModel in self.dataArray) {
        historyBillModel.selected = button.selected;
        if (historyBillModel.selected == YES) {
            self.totalPrice += historyBillModel.price;
            if (![self.billIdArray containsObject:historyBillModel.billId]) {
                
                [self.billIdArray addObject:historyBillModel.billId];
            }
        }else{
            [self.billIdArray removeObject:historyBillModel.billId];
        }
    }
    self.totalLabel.text = [NSString stringWithFormat:@"合计：%.2f元（满200元包邮）", self.totalPrice];

    [self.tableView reloadData];
    
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
    
    if (self.dataArray.count == 0) {
        
        return 0;
    }else {
    
        return 10;
    }
    
}

#pragma mark - BillHistoryCellDelegate
- (void)billHistoryCell:(BillHistoryCell *)cell didSelected:(BOOL)isSelected {
    NSLog(@"%s", __func__);
}

@end






