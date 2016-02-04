//
//  HistoryOrderViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/2/3.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "HistoryOrderViewController.h"
#import "OrderListEntity.h"
#import "OrderCenterTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface HistoryOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSMutableArray *arr_orderList;
@property (nonatomic ,strong)UITableView *tb_orderList;
@property (nonatomic ,strong)UIView *tab_backGroundView;

@end

@implementation HistoryOrderViewController

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
    self.title = @"历史订单";
//    [self.view addSubview:[UIView new]];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self onCreate];
    [self onNoOrderView];
    [self loadOrderList];

    // Do any additional setup after loading the view.
}

-(void)loadOrderList{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,QueryHistoryList];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"订单List:%@",responseDic);
        [self.tb_orderList.mj_header endRefreshing];
        [self.arr_orderList removeAllObjects];
        if ([Status isEqualToString:SUCCESS]) {
            NSArray *arr = [responseDic objectForKey:@"data"];
            if (arr.count > 0) {
                
                for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                    
                    [self.arr_orderList addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                    [self.tb_orderList reloadData];
                    [self.tb_orderList setBackgroundView:nil];
                }
            }else{
                [self.tb_orderList setBackgroundView:self.tab_backGroundView];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:Message];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
        [self.tb_orderList.mj_header endRefreshing];
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

-(void)onNoOrderView{
    self.tab_backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tb_orderList.frame.size.width, self.tb_orderList.frame.size.height)];
    UIImageView *img_nothing = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(self.tab_backGroundView.frame.size.height - 127)/2 - 80, 115, 127)];
    [self.tab_backGroundView addSubview:img_nothing];
    [img_nothing setImage:[UIImage imageNamed:@"nothingView"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img_nothing.frame) + 20 , SCREEN_WIDTH, 20)];
    [self.tab_backGroundView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您还没有历史订单哦～"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderListEntity *orderListEntity = [self.arr_orderList objectAtIndex:indexPath.row];
    [cell.lab_doctorName setText:orderListEntity.patientName];
    [cell.lab_hospitalName setText:[NSString stringWithFormat:@"地址:  %@",orderListEntity.hospitalName]];
    [cell.lab_timeStatus setText:orderListEntity.createTimeStr];
    [cell.imgStatus setImage:[UIImage imageNamed:@"ic_jiesu"]];
    if (orderListEntity.orderStatus == 4) {
        [cell.lab_orderStatus setText:@"订单已完成"];
    }
    if (orderListEntity.orderStatus == 5) {
        [cell.lab_orderStatus setText:@"订单已取消"];
    }
    [cell.lab_orderStatus setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    if (orderListEntity.orderType == 0) {
        NSString *orderT = @"类型:  普通陪诊";
        [cell.lab_orderType setText:orderT];
    }
    if (orderListEntity.orderType == 1) {
        NSString *orderT = @"类型:  特需陪诊";
        NSString *doctorN = [NSString stringWithFormat:@"医生:  %@",orderListEntity.doctorName];
        if (orderListEntity.doctorName == nil) {
            [cell.lab_orderType setText:orderT];
        }else{
            [cell.lab_orderType setText:[NSString stringWithFormat:@"%@      %@",orderT,doctorN]];
        }
    }
    
    return cell;
}


-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
