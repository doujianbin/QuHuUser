//
//  PuTongPZViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PuTongPZViewController.h"
#import "BaseTableViewCell.h"
#import "SelectFamilyViewController.h"
#import "TwoLevelViewController.h"
#import "PTSureOrderViewController.h"
#import "MemberEntity.h"

@interface PuTongPZViewController ()<UITableViewDataSource,UITableViewDelegate,SelectFamilyViewControllerDelegate>{
    UITableView *tableView1;
    UITableView *tableView2;
}

@property (nonatomic,strong)MemberEntity *entity;

@end

@implementation PuTongPZViewController

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
    
    // Do any additional setup after loading the view.
    [self addTableView];
    
}

-(void)addTableView{
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.5 + 64, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 11 + 64, SCREEN_WIDTH, 57 * 3 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.rowHeight = 57;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView1 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView1"];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21.5 + 57 * 3 + 64, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 22 + 57 * 3 + 64, SCREEN_WIDTH, 57 * 4 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.rowHeight = 57;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView2 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView2"];
    
    UILabel *lab_remark = [[UILabel alloc]initWithFrame:CGRectMake(15, 500, 300, 12.5)];
    [self.view addSubview:lab_remark];
    [lab_remark setText:@"备注：陪诊超时按照小时收费（￥60/小时）"];
    [lab_remark setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    lab_remark.font = [UIFont systemFontOfSize:12];
    
    UIButton *btn_xiadan = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self.view addSubview:btn_xiadan];
    [btn_xiadan setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [btn_xiadan setTitle:@"确认下单" forState:UIControlStateNormal];
    btn_xiadan.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn_xiadan addTarget:self action:@selector(btnxiadanAction) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView1) {
        return 3;
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
        if (indexPath.row == 0) {
            [cell.lab_left setText:@"地址"];
            [cell.lab_right setText:@"选择咨询地址"];
        }
        if (indexPath.row == 1) {
            [cell.lab_left setText:@"时间"];
            [cell.lab_right setText:@"选择陪诊时间"];
        }
        if (indexPath.row == 2) {
            [cell.lab_left setText:@"成员"];
            if (self.entity.name.length == 0) {
                [cell.lab_right setText:@"选择成员"];
            }else{
                [cell.lab_right setText:self.entity.name];
            }
        }
        return cell;
    }
    if (tableView == tableView2) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell.lab_left setText:@"服务"];
            [cell.lab_right setText:@"普通陪诊"];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A90E2"]];
            [cell.img_jiantou setHidden:YES];
            cell.lab_right.alpha = 1.0;
        }
        if (indexPath.row == 1) {
            [cell.lab_left setText:@"价格"];
            [cell.lab_right setText:@"¥199/4小时"];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
            [cell.img_jiantou setHidden:YES];
            cell.lab_right.alpha = 1.0;
        }
        if (indexPath.row == 2) {
            [cell.lab_left setText:@"优惠券"];
            [cell.lab_right setText:@"－¥99"];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            cell.lab_right.alpha = 1.0;
        }
        if (indexPath.row == 3) {
            [cell.lab_left setText:@"合计金额:"];
            cell.lab_left.alpha = 0.8;
            cell.lab_right.alpha = 1.0;
            [cell.lab_right setText:@"¥99"];
            [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            [cell.img_jiantou setHidden:YES];
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        if (indexPath.row == 0) {
            TwoLevelViewController *vc = [[TwoLevelViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            SelectFamilyViewController *seletView = [[SelectFamilyViewController alloc]init];
            seletView.delegate = self;
            [self.navigationController pushViewController:seletView animated:YES];
        }
    }
}

- (void)didSelectedMemberWithEntity:(MemberEntity *)memberEntity{
    self.entity = memberEntity;
    [tableView1 reloadData];
}

-(void)NavLeftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnxiadanAction{
    PTSureOrderViewController *orderView = [[PTSureOrderViewController alloc]init];
    [self.navigationController pushViewController:orderView animated:YES];
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
