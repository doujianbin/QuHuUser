//
//  SelectFamilyViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SelectFamilyViewController.h"
#import "FamileTableViewCell.h"
#import "AddFamilyViewController.h"
#import "NSString+Size.h"
#import "Toast+UIView.h"
#import "ModifyFamilyViewController.h"

@interface SelectFamilyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *tableFamily;
}
@property (nonatomic,strong)NSMutableArray   *arr_members;
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)UIView *tab_backGroundView;
@property (nonatomic ,strong)NSString *strFamilyId;
@property (nonatomic ,assign)int      int_selectedIndex;

@end

@implementation SelectFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"选择就诊人";
    // Do any additional setup after loading the view.
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 10, 30, 24)];
    [btnR setTitle:@"添加" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    btnR.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnright;
    [btnR addTarget:self action:@selector(btnRAdd) forControlEvents:UIControlEventTouchUpInside];

    [self addTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getFamilyData];
    
}

-(void)getFamilyData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetFamilyList];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"成员列表：%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            self.arr_members = [NSMutableArray array];
            if ([[responseDic objectForKey:@"data"] count] > 0) {

               for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                
                MemberEntity *entity = [[MemberEntity alloc]init];
                entity.userName = [dic objectForKey:@"userName"];
                entity.phoneNumber = [dic objectForKey:@"phoneNumber"];
                entity.idNo = [dic objectForKey:@"idNo"];
                entity.userId = [dic objectForKey:@"id"];// 就诊人的id
                entity.relation = [dic objectForKey:@"relation"];
                entity.zhurenID = [dic objectForKey:@"userId"];
                if ([[dic objectForKey:@"sex"] isEqualToString:@"0"]) {
                    
                    entity.sex = @"男";
                }else{
                    entity.sex = @"女";
                }
                entity.age = [dic objectForKey:@"age"];
                [self.arr_members addObject:entity];
            }
                [tableFamily reloadData];
                [tableFamily setBackgroundView:nil];
            }else{
                // 没有成员列表
                [tableFamily setBackgroundView:self.tab_backGroundView];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
        NetError;
    }];
}

-(void)addTableView{
    
    tableFamily = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableFamily];
    [tableFamily setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    tableFamily.delegate = self;
    tableFamily.dataSource = self;
    tableFamily.rowHeight = 72;
    tableFamily.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableFamily registerClass:[FamileTableViewCell class] forCellReuseIdentifier:@"tableView"];
    
    self.tab_backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,tableFamily.frame.size.width, tableFamily.frame.size.height)];
    UIImageView *img_nothing = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(self.tab_backGroundView.frame.size.height - 127)/2 - 80, 115, 127)];
    [self.tab_backGroundView addSubview:img_nothing];
    [img_nothing setImage:[UIImage imageNamed:@"nothingView"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img_nothing.frame) + 20 , SCREEN_WIDTH, 20)];
    [self.tab_backGroundView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您暂时还没有添加成员哦~"];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_members.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FamileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [cell addSubview:img1];
        [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    }
    MemberEntity *entity = [self.arr_members objectAtIndex:indexPath.row];
    CGFloat nameWith = [entity.userName fittingLabelWidthWithHeight:18 andFontSize:[UIFont systemFontOfSize:16]];
    [cell.lab_name setText:entity.userName];
    [cell.lab_name setFrame:CGRectMake(20, 15, nameWith, 18)];
    [cell.lab_sexAndphoneNum setFrame:CGRectMake(20 + 19 + nameWith, 15, 150, 18)];
    NSString *phoneFront = [entity.phoneNumber substringToIndex:3];
    NSString *phoneBehind = [entity.phoneNumber substringFromIndex:7];
    NSString *phoneNum = [NSString stringWithFormat:@"%@****%@",phoneFront, phoneBehind];
    if ([entity.sex isEqualToString:@"男"]) {
        
        NSString *str_genderAndphoneNum = [NSString stringWithFormat:@"男   %@",phoneNum];
        [cell.lab_sexAndphoneNum setText:str_genderAndphoneNum];
    }else{
        NSString *str_genderAndphoneNum = [NSString stringWithFormat:@"女   %@",phoneNum];
        [cell.lab_sexAndphoneNum setText:str_genderAndphoneNum];
    }
    NSString *idCardFront = [entity.idNo substringToIndex:entity.idNo.length - 6];
    NSString *idCard = [NSString stringWithFormat:@"%@******",idCardFront];
    [cell.lab_IDCard setText:[NSString stringWithFormat:@"身份证号: %@",idCard]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.FromVc == NO) {
        
        MemberEntity *entity = [self.arr_members objectAtIndex:indexPath.row];
        [self.delegate didSelectedMemberWithEntity:entity];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        MemberEntity *entity = [self.arr_members objectAtIndex:indexPath.row];
        self.strFamilyId = entity.userId;
        self.int_selectedIndex = (int)indexPath.row;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确认删除就诊人档案？删除后就诊人将同时删除！" delegate:self cancelButtonTitle:@"确认删除" otherButtonTitles:@"再想想", nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];

    }];
    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#fa6262"];
    
    
    UITableViewRowAction *modifyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        MemberEntity *entity = [self.arr_members objectAtIndex:indexPath.row];
        ModifyFamilyViewController *vc = [[ModifyFamilyViewController alloc]init];
        vc.memberEntity = entity;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    modifyRowAction.backgroundColor = [UIColor colorWithHexString:@"#a4a4a4"];
    
    return @[deleteRowAction,modifyRowAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,DeleteFamily];
            NSDictionary *dic = @{@"id":self.strFamilyId};
            self.manager = [[AFNManager alloc]init];
            [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
                NSLog(@"删除结果:%@",responseDic);
                if ([Status isEqualToString:SUCCESS]) {
                    [self.view makeToast:@"删除成功" duration:1.0 position:@"center"];
                    [self.arr_members removeObjectAtIndex:self.int_selectedIndex];
                    [tableFamily deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.int_selectedIndex inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    FailMessage;
                    [tableFamily reloadData];
                }
            } fail:^(NSError *error) {
                NetError;
                [tableFamily reloadData];
            }];
        }
    }
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnRAdd{
    AddFamilyViewController *addView = [[AddFamilyViewController alloc]init];
    [self.navigationController pushViewController:addView animated:YES];
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
