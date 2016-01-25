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
        if ([Status isEqualToString:SUCCESS]) {
            
            for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                [self.arr_orderList addObject:[OrderListEntity parseOrderListEntityWithJson:dic]];
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
    [self.tb_orderList setRowHeight:186];
    [self.tb_orderList setSeparatorColor:[UIColor clearColor]];
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
    [cell.textLabel setText:orderListEntity.doctorName];
    
    return cell;
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
