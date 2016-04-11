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
#import "HistoryOrderViewController.h"
#import "SignInViewController.h"
#import "Toast+UIView.h"
#import "NotCompleteTableViewCell.h"
#import "CompleteTableViewCell.h"
#import "EvaluateViewController.h"
#import "PayViewController.h"
#import "CancelOrderDetailViewController.h"
#import "CompleteOrderDetailViewController.h"

@interface YuYueViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSMutableArray *arr_orderList;
@property (nonatomic ,strong)UITableView *tb_orderList;
@property (nonatomic ,strong)UIView *tab_backGroundView;
@property (nonatomic ,strong)NSMutableArray *arr_weiwancheng;
@property (nonatomic ,strong)NSMutableArray *arr_yiwancheng;
@property (nonatomic ,strong)NSString *nursePhoneNumber;
@property (nonatomic )int pageNo;

@property (nonatomic ,strong)NSString *deleteOrderId;
@property (nonatomic ,assign)int      int_selectedIndex;

@end

@implementation YuYueViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_orderList = [[NSMutableArray alloc]init];
        self.arr_weiwancheng = [[NSMutableArray alloc]init];
        self.arr_yiwancheng = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tabBarController.tabBar.translucent = NO;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    //    [self.view setBackgroundColor:[UIColor yellowColor]];
    self.title = @"订单";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    
    [self onCreate];
    [self onNoOrderView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadOrderList];
    //    [self.tabBarController.tabBar setHidden:NO];
}


-(void)loadOrderList{
    
    [self.tb_orderList.mj_footer resetNoMoreData];
    self.pageNo = 1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetOrderList];
    NSDictionary *dic = @{@"pageNo":[NSString stringWithFormat:@"%d",self.pageNo]};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"订单List:%@",responseDic);
        [self.tb_orderList.mj_header endRefreshing];
        if ([Status isEqualToString:SUCCESS]) {
            
            NSArray *arr = [responseDic objectForKey:@"data"];
            [self.arr_orderList removeAllObjects];
            [self.arr_weiwancheng removeAllObjects];
            [self.arr_yiwancheng removeAllObjects];
            for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                if ([[dic objectForKey:@"orderStatus"] intValue] == 0 || [[dic objectForKey:@"orderStatus"] intValue] == 1 || [[dic objectForKey:@"orderStatus"] intValue] == 2 ||[[dic objectForKey:@"orderStatus"] intValue] == 3) {
                    [self.arr_weiwancheng addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                }else{
                    [self.arr_yiwancheng addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                }
            }
            [self.arr_orderList addObjectsFromArray:self.arr_weiwancheng];
            [self.arr_orderList addObjectsFromArray:self.arr_yiwancheng];
            [self.tb_orderList reloadData];
            if (arr.count > 0) {
                [self.tb_orderList setBackgroundView:nil];
                self.pageNo++;
            }else{
                [self.tb_orderList setBackgroundView:self.tab_backGroundView];
            }
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        
        NetError;
        [self.tb_orderList.mj_header endRefreshing];
    }];
    
}

-(void)footerLoadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetOrderList];
    NSDictionary *dic = @{@"pageNo":[NSString stringWithFormat:@"%d",self.pageNo]};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"订单List:%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            [self.arr_orderList removeAllObjects];
            NSArray *arr = [responseDic objectForKey:@"data"];
            for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                if ([[dic objectForKey:@"orderStatus"] intValue] == 0 || [[dic objectForKey:@"orderStatus"] intValue] == 1 || [[dic objectForKey:@"orderStatus"] intValue] == 2 ||[[dic objectForKey:@"orderStatus"] intValue] == 3) {
                    [self.arr_weiwancheng addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                }else{
                    [self.arr_yiwancheng addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
                }
            }
            [self.arr_orderList addObjectsFromArray:self.arr_weiwancheng];
            [self.arr_orderList addObjectsFromArray:self.arr_yiwancheng];
            [self.tb_orderList reloadData];
            if (arr.count > 0) {
                self.pageNo++;
                [self.tb_orderList.mj_footer endRefreshing];
            }else{
                [self.tb_orderList.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        
        NetError;
        [self.tb_orderList.mj_footer endRefreshing];
    }];
}

-(void)onCreate{
    
    self.tb_orderList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44- 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tb_orderList];
    [self.tb_orderList setDataSource:self];
    [self.tb_orderList setDelegate:self];
    //    [self.tb_orderList setRowHeight:149.5];
    [self.tb_orderList setSeparatorColor:[UIColor clearColor]];
    [self.tb_orderList setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.tb_orderList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadOrderList];
    }];
    self.tb_orderList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerLoadData];
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
    [lab setText:@"您还没有订单哦～"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_orderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != self.arr_weiwancheng.count) {
        return nil;
    }else{
        UIView *v_section = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [v_section setBackgroundColor:[UIColor colorWithHexString:@"#f5f5f9"]];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 35, 13, 70, 15)];
        [v_section addSubview:lab];
        [lab setText:@"历史订单"];
        [lab setTextColor:[UIColor colorWithHexString:@"#929292"]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setFont:[UIFont systemFontOfSize:14]];
        
        UIImageView *img_line1 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 21, SCREEN_WIDTH / 2 - 50 - 40, 0.5)];
        [v_section addSubview:img_line1];
        [img_line1 setBackgroundColor:[UIColor colorWithHexString:@"#e8e8eb"]];
        
        UIImageView *img_line2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 40, 21, SCREEN_WIDTH / 2 - 50 - 40, 0.5)];
        [v_section addSubview:img_line2];
        [img_line2 setBackgroundColor:[UIColor colorWithHexString:@"#e8e8eb"]];
        
        return v_section;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.arr_weiwancheng.count) {
        return 147;
    }else{
        return 104;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.arr_weiwancheng.count) {
        return 50;
    }else{
        if (section == 0) {
            return 10;
        }else{
            return 5;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.arr_weiwancheng.count - 1)
    {
        return 0;
    }else{
        return 5;
    }
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.arr_weiwancheng.count) {
        static NSString *CellIdentifier = @"weiwancheng";
        NotCompleteTableViewCell *cell = (NotCompleteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[NotCompleteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //        cell.backgroundColor = [UIColor yellowColor];
        OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.section];
        NSString *time = [entity.scheduleTime substringFromIndex:5];
        NSString *scheduleT = [time substringToIndex:time.length - 3];
        [cell.lab_time setText:scheduleT];
        
        if (entity.orderStatus == 0) {
            [cell.lab_status setText:@"待接单"];
            [cell.lab_price setText:@""];
            [cell.btnAction setTitle:@"正在派单" forState:UIControlStateNormal];
        }
        if (entity.orderStatus == 1) {
            [cell.lab_status setText:@"待陪诊"];
            [cell.lab_price setText:@""];
            [cell.btnAction setTitle:@"护士电话" forState:UIControlStateNormal];
        }
        if (entity.orderStatus == 2) {
            [cell.lab_status setText:@"陪诊中"];
            [cell.lab_price setText:@""];
            [cell.btnAction setTitle:@"护士电话" forState:UIControlStateNormal];
        }
        if (entity.orderStatus == 3) {
            [cell.lab_status setText:@"待支付"];
            [cell.lab_price setText:[NSString stringWithFormat:@"%@元",entity.totalAmount]];
            [cell.btnAction setTitle:@"去支付" forState:UIControlStateNormal];
        }
        [cell.lab_name setText:entity.patientName];
        [cell.lab_hospital setText:entity.hospitalName];
        cell.btnAction.tag = indexPath.section;
        [cell.btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        static NSString *CellIdentifier = @"yiwancheng";
        CompleteTableViewCell *cell = (CompleteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[CompleteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //        [cell setBackgroundColor:[UIColor redColor]];
        OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.section];
        NSString *time = [entity.scheduleTime substringFromIndex:5];
        NSString *scheduleT = [time substringToIndex:time.length - 3];
        [cell.lab_time setText:scheduleT];
        if (entity.orderStatus == 4) {
            [cell.lab_status setText:@"已完成"];
        }
        if (entity.orderStatus == 5) {
            [cell.lab_status setText:@"已关闭"];
        }
        [cell.lab_name setText:entity.patientName];
        [cell.lab_hospital setText:entity.hospitalName];
        if (entity.orderStatus == 4) {
            if (entity.stars == 0) {
                [cell.lab_price setText:@"未评价"];
                [cell.lab_price setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_price setFont:[UIFont systemFontOfSize:17]];
                
            }else{
                [cell.lab_price setText:[NSString stringWithFormat:@"%@元",entity.totalAmount]];
                [cell.lab_price setTextColor:[UIColor colorWithHexString:@"#929292"]];
                [cell.lab_price setFont:[UIFont systemFontOfSize:20]];
            }
        }else{
            [cell.lab_price setText:@""];
        }
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.arr_weiwancheng.count) {
        
        OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.section];
        PTSureOrderViewController *vc = [[PTSureOrderViewController alloc]init];
        vc.str_OrderId = entity._id;
        vc.orderFromType = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.section];
        if (entity.orderStatus == 4) {
            if (entity.stars > 0) {
                // 已完成订单详情
                CompleteOrderDetailViewController *vc = [[CompleteOrderDetailViewController alloc]init];
                vc.orderId = entity._id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                // 评价界面
                EvaluateViewController *vc = [[EvaluateViewController alloc]init];
                vc.orderId = entity._id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            // 已关闭订单详情界面
            CancelOrderDetailViewController *vc = [[CancelOrderDetailViewController alloc]init];
            vc.orderId = entity._id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= self.arr_weiwancheng.count) {
        // 添加一个删除按钮
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            OrderListEntity *entity = [self.arr_orderList objectAtIndex:indexPath.section];
            self.deleteOrderId = entity._id;
            
            self.int_selectedIndex = (int)indexPath.section;
            
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,DeleteOrder];
            NSDictionary *dic = @{@"id":self.deleteOrderId};
            self.manager = [[AFNManager alloc]init];
            [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
                if ([Status isEqualToString:SUCCESS]) {
                    [self.view makeToast:@"删除成功" duration:1.0 position:@"center"];
                    [self.arr_orderList removeObjectAtIndex:self.int_selectedIndex];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:self.int_selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    FailMessage;
                }
            } fail:^(NSError *error) {
                NetError;
            }];
        }];
        deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#fa6262"];
        return @[deleteRowAction];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.arr_weiwancheng.count) {
        return YES;
    }
    return NO;
}


-(void)deleteHistoryOrder{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,DeleteOrder];
    NSDictionary *dic = @{@"id":self.deleteOrderId};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            [self.arr_orderList removeObjectAtIndex:self.int_selectedIndex];
            [self.tb_orderList reloadData];
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NetError;
    }];
}


-(void)btnAction:(UIButton *)sender{
    OrderListEntity *entity = [self.arr_orderList objectAtIndex:sender.tag];
    if ([sender.titleLabel.text isEqualToString:@"护士电话"]) {
        self.nursePhoneNumber = entity.nursePhoneNumber;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系护士" message:entity.nursePhoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
        alert.tag = 151;
        alert.delegate = self;
        [alert show];
    }
    if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
        PayViewController *vc = [[PayViewController alloc]init];
        vc.str_OrderId = entity._id;
        vc.orderNo = entity.orderNo;
        vc.totalAmount = entity.totalAmount;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 151) {
        if (buttonIndex == 1) {
            NSString *str1 = @"tel://";
            NSString *str2 = self.nursePhoneNumber;
            NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
        }
    }
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
