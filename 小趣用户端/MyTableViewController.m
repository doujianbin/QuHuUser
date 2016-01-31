//
//  MyViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MyTableViewController.h"

#import "PersonDataCell.h"
#import "MyCell.h"

#import "CouponsTableViewController.h"
#import "BillTableViewController.h"
#import "ShareViewController.h"
#import "SettingTableViewController.h"
#import "ChangeMyDataViewController.h"


@interface MyTableViewController ()<changeMyDataViewControllerDelegate>

@property (nonatomic, strong)NSArray *personCenterImageArray;

@property (nonatomic, strong)NSArray *personCenterLabelArray;

@property (nonatomic, weak)PersonDataCell *personDataCell;

@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation MyTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self makeNSURLRequest];
}

- (void)makeNSURLRequest {
    
    AFNManager *manager = [AFNManager shareManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/queryPersonalInfo",Development];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"nickname"];
    
    if (userName == nil) {
        userName = @"123";
    }
    NSDictionary *dic = @{@"userId":userName};
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
        
        NSLog(@"~~~~~success %@",responseDic);
        
        self.personDataCell.nameLabel.text = [responseDic objectForKey:@"nickName"];

        self.personDataCell.creditLabel.text = [[responseDic objectForKey:@"integralIn"]stringValue];

        
    } fail:^(NSError *error) {
        
        NSLog(@"~~~~~~~~~fail %@",error);
    }];
}

#pragma mark 页面设置相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 0) {
        return 1;
    }else {
        return self.personCenterLabelArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
       
        return 90;
    }else {
        return 57;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    
    headerView.backgroundColor = COLOR(245, 246, 247, 1);
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;

    static NSString *cellId1 = @"cell1";
    static NSString *cellId2 = @"cell2";
    
    if (section == 0) {
        PersonDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            
            cell = [[PersonDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
            
        }
        
        cell.iconImageView.image = [UIImage imageNamed:@"coupons"];
        
        self.personDataCell = cell;
        
        return cell;

    }else {
            MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
            if (cell == nil) {

                cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
                
            }
        
        cell.iconImageView.image = [UIImage imageNamed:self.personCenterImageArray[indexPath.row]];
        cell.personCenterLabel.text = self.personCenterLabelArray[indexPath.row];
        
        return cell;
        
    }
    
    
}

#pragma mark Cell点击事件相关
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            ChangeMyDataViewController *changeMyDataViewController = [[ChangeMyDataViewController alloc]init];
            changeMyDataViewController.delegate = self;
            [self.navigationController pushViewController:changeMyDataViewController animated:YES];
            
        }
    }else {
        if (row == 1) {
            CouponsTableViewController *couponsViewController = [[CouponsTableViewController alloc]init];
            [self.navigationController pushViewController:couponsViewController animated:YES];
        }
        
        if (row == 2) {
            BillTableViewController *billTableViewController = [[BillTableViewController alloc]init];
            [self.navigationController pushViewController:billTableViewController animated:YES];
            self.tabBarController.tabBar.hidden = YES;
        }
        
        if (row == 3) {
            ShareViewController *shareViewController = [[ShareViewController alloc]init];
            [self.navigationController pushViewController:shareViewController animated:YES];
        }
        
        if (row == 4) {
            SettingTableViewController *settingTvc = [[SettingTableViewController alloc]init];
            [self.navigationController pushViewController:settingTvc animated:YES];
        }
    }
}


#pragma mark 懒加载数据
- (NSArray *)personCenterImageArray {
    if (!_personCenterImageArray) {
        _personCenterImageArray = [NSArray arrayWithObjects:@"member",@"coupons",@"bill",@"share",@"setting", nil];
    }
    return _personCenterImageArray;
}

- (NSArray *)personCenterLabelArray {
    if (!_personCenterLabelArray) {
        _personCenterLabelArray = [NSArray arrayWithObjects:@"我的成员",@"优惠券",@"发票",@"推荐有奖",@"设置", nil];
    }
    return _personCenterLabelArray;
}

#pragma mark 自定义协议实现
- (void)changeMyDataViewControllerDidChangeName:(NSString *)name {

    self.personDataCell.nameLabel.text = name;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        
        
    }
    return _dataArray;
}


@end






