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
#import "SettingTableViewController.h"
#import "ChangeMyDataViewController.h"
#import "SignInViewController.h"
#import "SelectFamilyViewController.h"
#import "UserInfoDetailViewController.h"
#import "PatientViewController.h"

@interface MyTableViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)NSArray *personCenterImageArray;

@property (nonatomic, strong)NSArray *personCenterLabelArray;

@property (nonatomic, weak)PersonDataCell *personDataCell;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSString *points;
@property (nonatomic ,strong)NSString *str_points;

@end

@implementation MyTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"个人中心";
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAgainAction) name:@"loginIn" object:nil];
}

-(void)loginAgainAction{
    SignInViewController *sign = [[SignInViewController alloc]init];
    sign.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sign animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([LoginStorage isLogin] == YES) {
        
        [self makeNSURLRequest];
    }
    [self.tableView reloadData];
}

- (void)makeNSURLRequest {
    
    AFNManager *manager = [[AFNManager alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/queryPersonalInfo",Development];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
        
        NSLog(@"~~~~~success %@",responseDic);
        
        self.points = [NSString stringWithFormat:@"%@  积分",[[responseDic objectForKey:@"data"]objectForKey:@"points"]];
        self.str_points = [NSString stringWithFormat:@"%@",[[responseDic objectForKey:@"data"]objectForKey:@"points"]];
//        NSString *nickName = [[responseDic objectForKey:@"data"]objectForKey:@"nickName"];
//        if ([nickName isKindOfClass:[NSNull class]]) {
//           self.personDataCell.nameLabel.text = @"小趣好护士";
//        }else{
//            self.personDataCell.nameLabel.text = nickName;
//        }
//        self.personDataCell.creditLabel.text = [[responseDic objectForKey:@"data"]objectForKey:@"points"];
//        
//        NSString *url = [[responseDic objectForKey:@"data"]objectForKey:@"photo"];
//
//        if ([url isKindOfClass:[NSNull class]]) {
//            
//            self.personDataCell.iconImageView.image = [UIImage imageNamed:@"morenicon"];
//
//        }else {
//        
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            self.personDataCell.iconImageView.image = [UIImage imageWithData:imageData];
//
//        }
//        
//
        [self.tableView reloadData];
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;

    static NSString *cellId1 = @"cell1";
    static NSString *cellId2 = @"cell2";
    
    if (section == 0) {
        PersonDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
            
            cell = [[PersonDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
            
            if ([LoginStorage isLogin] == YES) {
                if (self.points.length > 0) {
                    
                    NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:self.points];
                    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffc73d"] range:NSMakeRange(0,myStr.length - 4)];
                    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, myStr.length - 4)];
                    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9b9b9b"] range:NSMakeRange(myStr.length - 4, 2)];
                    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(myStr.length - 4,2)];
                    [cell.creditLabel setAttributedText:myStr];
                }
                NSString *nickName = [LoginStorage GetnickName];
                if (nickName.length == 0) {
                    cell.nameLabel.text = @"小趣好护士";
                }else{
                    cell.nameLabel.text = nickName;
                }
                
                NSString *url = [LoginStorage Getphoto];
                
                if (url.length == 0) {
                    
                    cell.iconImageView.image = [UIImage imageNamed:@"HeadImg"];
                    cell.iconImageView.layer.borderColor = [[UIColor clearColor] CGColor];
                    
                }else {
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    cell.iconImageView.image = [UIImage imageWithData:imageData];
                    
                }
            }else{
                cell.iconImageView.image = [UIImage imageNamed:@"HeadImg"];
                cell.iconImageView.layer.borderColor = [[UIColor clearColor] CGColor];
                cell.nameLabel.text = @"登录/注册";
            }
        
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
            if ([LoginStorage isLogin] == YES) {
                
//                ChangeMyDataViewController *changeMyDataViewController = [[ChangeMyDataViewController alloc]init];
//                
//                changeMyDataViewController.personImage = self.personDataCell.iconImageView.image;
//                changeMyDataViewController.personName = self.personDataCell.nameLabel.text;
                UserInfoDetailViewController *vc = [[UserInfoDetailViewController alloc]init];
                vc.points = self.str_points;
                vc.nickName = [LoginStorage GetnickName];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                SignInViewController *vc = [[SignInViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }else {
        if (row == 0) {
            if ([LoginStorage isLogin] == YES) {
                PatientViewController *vc = [[PatientViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                SignInViewController *vc = [[SignInViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (row == 1) {
            if ([LoginStorage isLogin] == YES) {
                CouponsTableViewController *couponsViewController = [[CouponsTableViewController alloc]init];
                couponsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:couponsViewController animated:YES];
            }else{
                SignInViewController *vc = [[SignInViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if (row == 2) {
            if ([LoginStorage isLogin] == YES) {
                BillTableViewController *billTableViewController = [[BillTableViewController alloc]init];
                billTableViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billTableViewController animated:YES];
            }else{
                SignInViewController *vc = [[SignInViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        
//        if (row == 3) {
//            if ([LoginStorage isLogin] == YES) {
//                ShareViewController *shareViewController = [[ShareViewController alloc]init];
//                shareViewController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:shareViewController animated:YES];
//            }else{
//                SignInViewController *vc = [[SignInViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//    
//        }
        
        if (row == 3) {
            SettingTableViewController *settingTvc = [[SettingTableViewController alloc]init];
            settingTvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingTvc animated:YES];
        }
    }
}


#pragma mark 懒加载数据
- (NSArray *)personCenterImageArray {
    if (!_personCenterImageArray) {
        _personCenterImageArray = [NSArray arrayWithObjects:@"1.1个人中心@2x_03",@"coupons",@"bill",@"设置icon", nil];
    }
    return _personCenterImageArray;
}

- (NSArray *)personCenterLabelArray {
    if (!_personCenterLabelArray) {
        _personCenterLabelArray = [NSArray arrayWithObjects:@"就诊人档案",@"优惠券",@"发票",@"设置", nil];
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






