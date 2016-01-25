//
//  YuYueViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "YuYueViewController.h"
#import "OrderListEntity.h"
#import "OrderCenterTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "PTSureOrderViewController.h"
@interface YuYueViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSMutableArray *arr_orderList;
@property (nonatomic ,strong)UITableView *tb_orderList;

@end

@implementation YuYueViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_orderList = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"订单";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    // Do any additional setup after loading the view.
    [self onCreate];
    [self loadOrderList];
}

-(void)loadOrderList{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,QueryUnfinishedList];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"订单List:%@",responseDic);
        [self.tb_orderList.mj_header endRefreshing];
        [self.arr_orderList removeAllObjects];
        if ([Status isEqualToString:SUCCESS]) {
            
            for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                [self.arr_orderList addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                [self.tb_orderList reloadData];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:Message];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];

}

-(void)onCreate{
    self.tb_orderList = [[UITableView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, SCREEN_HEIGHT - 7.5) style:UITableViewStylePlain];
    [self.view addSubview:self.tb_orderList];
    [self.tb_orderList setDataSource:self];
    [self.tb_orderList setDelegate:self];
    [self.tb_orderList setRowHeight:149.5];
    [self.tb_orderList setSeparatorColor:[UIColor clearColor]];
    [self.tb_orderList setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.tb_orderList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadOrderList];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_orderList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"OrderCenterCell";
    OrderCenterTableViewCell *cell = (OrderCenterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[OrderCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    OrderListEntity *orderListEntity = [self.arr_orderList objectAtIndex:indexPath.row];
    [cell.lab_doctorName setText:orderListEntity.patientName];
    [cell.lab_hospitalName setText:[NSString stringWithFormat:@"地址:  %@",orderListEntity.hospitalName]];
    [cell.lab_timeStatus setText:orderListEntity.createTimeStr];
    
    if (orderListEntity.orderType == 0) {
        NSString *orderT = @"类型:  普通陪诊";
        [cell.lab_orderType setText:orderT];
        if (orderListEntity.orderStatus == 0 || orderListEntity.orderStatus == 3) {
            [cell.imgStatus setImage:[UIImage imageNamed:@"ic_dengdai"]];
            if (orderListEntity.orderStatus == 0) {
                [cell.lab_orderStatus setText:@"等待护士接单"];
            }
            if (orderListEntity.orderStatus == 3) {
                [cell.lab_orderStatus setText:@"等待支付"];
            }
        }
        if (orderListEntity.orderStatus == 1 || orderListEntity.orderStatus == 2) {
            [cell.imgStatus setImage:[UIImage imageNamed:@"ic_chenggong"]];
            if (orderListEntity.orderStatus == 1) {
                [cell.lab_orderStatus setText:@"护士已结单"];
            }
            if (orderListEntity.orderStatus == 2) {
                [cell.lab_orderStatus setText:@"陪诊中"];
            }
        }
    }
    if (orderListEntity.orderType == 1) {
        NSString *orderT = @"类型:  特需陪诊";
        NSString *doctorN = [NSString stringWithFormat:@"医生:  %@",orderListEntity.doctorName];
        [cell.lab_orderType setText:[NSString stringWithFormat:@"%@      %@",orderT,doctorN]];
        if (orderListEntity.orderStatus == 0) {
            [cell.imgStatus setImage:[UIImage imageNamed:@"ic_dengdai"]];
            if (orderListEntity.payStatus == 0) {
                [cell.lab_orderStatus setText:@"等待支付"];
            }
            if (orderListEntity.payStatus == 1) {
                [cell.lab_orderStatus setText:@"等待护士接单"];
            }
        }else{
            [cell.imgStatus setImage:[UIImage imageNamed:@"ic_chenggong"]];
            if (orderListEntity.orderStatus == 1) {
                [cell.lab_orderStatus setText:@"护士已接单"];
            }
            if (orderListEntity.orderStatus == 2) {
                [cell.lab_orderStatus setText:@"陪诊中"];
            }
            if (orderListEntity.orderStatus == 3) {
                [cell.lab_orderStatus setText:@"陪诊完成"];
            }
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.row];
    PTSureOrderViewController *vc = [[PTSureOrderViewController alloc]init];
    vc.str_OrderId = entity._id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
