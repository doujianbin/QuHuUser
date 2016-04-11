//
//  PatientViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientViewController.h"
#import "AddFamilyViewController.h"
#import "Toast+UIView.h"
#import "PatientEntity.h"
#import "PatientTableViewCell.h"
#import "PatientDetailViewController.h"
#import "EditPatientViewController.h"
#import "MemberEntity.h"

@interface PatientViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)NSString * pageNo;
@property (nonatomic ,strong)UITableView *tb_patient;
@property (nonatomic ,strong)NSMutableArray *arr_patient;
@property (nonatomic ,strong)UIView *tab_backGroundView;
@property (nonatomic ,strong)NSString * strFamilyId;
@property (nonatomic ) int int_selectedIndex;


@end

@implementation PatientViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_patient = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看档案";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
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
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    // Do any additional setup after loading the view.
    self.pageNo = @"1";
    [self onCreate];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetFamilyList];
    AFNManager *manager = [[AFNManager alloc]init];
//    NSDictionary *dic = @{@"pageNo":self.pageNo};
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            [self.arr_patient removeAllObjects];
            NSArray *arr = [responseDic objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                [self.arr_patient addObject:[MemberEntity parseMemberEntityWithJson:dic]];
            }
            [self.tb_patient reloadData];
            if (arr.count > 0) {
                [self.tb_patient setBackgroundView:nil];
            }else{
                [self.tb_patient setBackgroundView:self.tab_backGroundView];
            }
            
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NetError;
    }];
    
}

-(void)onCreate{
    self.tb_patient = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tb_patient];
    self.tb_patient.dataSource = self;
    self.tb_patient.delegate = self;
    self.tb_patient.rowHeight = 57;
    [self.tb_patient setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    self.tb_patient.separatorColor = [UIColor clearColor];
    
    self.tab_backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tb_patient.frame.size.width, self.tb_patient.frame.size.height)];
    UIImageView *img_nothing = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(self.tab_backGroundView.frame.size.height - 127)/2 - 80, 115, 127)];
    [self.tab_backGroundView addSubview:img_nothing];
    [img_nothing setImage:[UIImage imageNamed:@"nothingView"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img_nothing.frame) + 20 , SCREEN_WIDTH, 20)];
    [self.tab_backGroundView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您还没有添加就诊人哦～"];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_patient.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PatientCell";
    PatientTableViewCell *cell = (PatientTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[PatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    MemberEntity *entity = [self.arr_patient objectAtIndex:indexPath.row];
    [cell.lab_username setText:[NSString stringWithFormat:@"%@的档案",entity.userName]];
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
        // 添加一个删除按钮
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            MemberEntity *entity = [self.arr_patient objectAtIndex:indexPath.row];
            self.strFamilyId = entity.userId;
            self.int_selectedIndex = (int)indexPath.row;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确认删除就诊人？删除后就诊人档案将同时删除！" delegate:self cancelButtonTitle:@"确认删除" otherButtonTitles:@"再想想", nil];
            [alert show];

        }];
        deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#fa6262"];
        
        
        return @[deleteRowAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberEntity *entity = [self.arr_patient objectAtIndex:indexPath.row];
    PatientDetailViewController *vc = [[PatientDetailViewController alloc]init];
    vc.patientEntity = entity;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,DeleteFamily];
        NSDictionary *dic = @{@"id":self.strFamilyId};
        AFNManager *manager = [[AFNManager alloc]init];
        [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
            NSLog(@"删除结果:%@",responseDic);
            if ([Status isEqualToString:SUCCESS]) {
                [self.view makeToast:@"删除成功" duration:1.0 position:@"center"];
                [self.arr_patient removeObjectAtIndex:self.int_selectedIndex];
                [self.tb_patient deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.int_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else{
                FailMessage;
                [self.tb_patient reloadData];
            }
        } fail:^(NSError *error) {
            NetError;
        }];
    }else{
        [self.tb_patient reloadData];
    }
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnRAdd{
    AddFamilyViewController *vc = [[AddFamilyViewController alloc]init];
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
