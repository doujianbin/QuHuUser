//
//  PTSureOrderViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PTSureOrderViewController.h"
#import "BaseTableViewCell.h"


@interface PTSureOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView1;
    UITableView *tableView2;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    UIScrollView *scl_back;
}

@end

@implementation PTSureOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arr1 = [[NSMutableArray alloc]initWithObjects:@"订单号",@"下单时间",@"地址",@"时间",@"成员", nil];
        arr2 = [[NSMutableArray alloc]initWithObjects:@"服务",@"价格",@"优惠券",@"合计金额", nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"确认订单";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];

    scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scl_back];
    // Do any additional setup after loading the view.
    [self addtableView];
}

-(void)addtableView{
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.5, SCREEN_WIDTH, 0.5)];
    [scl_back addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 296 + 64) style:UITableViewStylePlain];
    [scl_back addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView1 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView1"];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 296 + 11 + 10.5, SCREEN_WIDTH, 0.5)];
    [scl_back addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 296 + 11 + 11, SCREEN_WIDTH, 57 * 4) style:UITableViewStylePlain];
    [scl_back addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView2 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView2"];
    
    UILabel *lab_remark = [[UILabel alloc]initWithFrame:CGRectMake(15, 557, 300, 12.5)];
    [scl_back addSubview:lab_remark];
    [lab_remark setText:@"备注：陪诊超时按照小时收费（￥60/小时）"];
    [lab_remark setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    lab_remark.font = [UIFont systemFontOfSize:12];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 586, SCREEN_WIDTH, 54)];
    [scl_back addSubview:upView];
    [upView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(14.5, 17, 20, 20)];
    [upView addSubview:img];
    [img setImage:[UIImage imageNamed:@"Oval 91 + Path 52"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(42, 16.5, 85, 21)];
    [upView addSubview:lab];
    [lab setText:@"等待支付"];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor colorWithHexString:@"#FA6262"];
    
    UIButton *btn_zhifu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
    [upView addSubview:btn_zhifu];
    [btn_zhifu setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [btn_zhifu setTitle:@"支付" forState:UIControlStateNormal];
    btn_zhifu.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, 640)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
            return 57;
        }
        if (indexPath.row == 1) {
            return 55;
        }
        if (indexPath.row == 2) {
            return 70;
        }
    }
    if (tableView == tableView2) {
        return 57;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView1) {
        return 5;
    }
    if (tableView == tableView2) {
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img_jiantou setHidden:YES];
        [cell.lab_left setText:[arr1 objectAtIndex:indexPath.row]];
        return cell;
    }
    if (tableView == tableView2) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img_jiantou setHidden:YES];
        [cell.lab_left setText:[arr2 objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
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
