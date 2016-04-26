//
//  BillRecordTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BillRecordTableViewController.h"

#import "BillRecordCell.h"
#import "UIBarButtonItem+Extention.h"
#import <MJRefresh/MJRefresh.h>
#import "Toast+UIView.h"

@interface BillRecordTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end
@implementation BillRecordTableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开票历史";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeNSURLRequest];
    }];
    
    [self makeNSURLRequest];

}

- (void)makeNSURLRequest {

    BeginActivity;
    AFNManager *manager = [[AFNManager alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/invoice/queryUserInvoiceHistory",Development];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
        [self.tableView.mj_header endRefreshing];
        if (SUCCESS) {
            EndActivity;
            NSLog(@"~~~~~success %@",responseDic);
//            [self.dataArray removeAllObjects];

            self.dataArray = [responseDic objectForKey:@"data"];
            
            [self.tableView reloadData];
            
            if (self.dataArray.count == 0) {
                
                [self setupInterface];
            }
            
        }else {
        
            FailMessage;
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        EndActivity;
        NetError;
        NSLog(@"#####fail %@",error);
    }];
    
}

- (void)setupInterface {

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:tableView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(SCREEN_HEIGHT - 127)/2 - 110, 115, 127)];
    
    imageView.image = [UIImage imageNamed:@"nothingView"];
    
    //        imageView.contentMode = UIViewContentModeCenter;
    
    tableView.backgroundColor = COLOR(245, 246, 247, 1);
    
    [tableView addSubview:imageView];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame) + 20 , SCREEN_WIDTH, 20)];
    [tableView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您还没有开过发票哦～"];
}

- (void)backItemClick {
    if (self.isFromKaifapiao == YES) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        
        return 0;
    }else {
    
        NSLog(@"dataArray.count == %ld",self.dataArray.count);
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    BillRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BillRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
//    "amount": 100,//开发票金额
//    "create_time": 1453182322000,//时间
//    "order_type": 1,//订单类型;0-普通;1-特需
//    "status": 0//状态，0正在处理，1已开发票
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSMutableAttributedString *chargeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"专业陪诊%@元",[dic objectForKey:@"amount"]]];
    [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(74, 74, 74, 1) range:NSMakeRange(0, 4)];
    [chargeString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:NSMakeRange(4, chargeString.length - 4)];
    cell.chargeLabel.attributedText = chargeString;
    NSString *CreTime = [dic objectForKey:@"create_time"];
    NSString *time = [CreTime substringToIndex:CreTime.length - 3];
    cell.dateLabel.text = time;
    
    NSString *status = [[dic objectForKey:@"status"]stringValue];
    
    if ([status isEqualToString:@"0"]) {

        cell.billStateLabel.text = @"正在处理";
    }else {
    
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







