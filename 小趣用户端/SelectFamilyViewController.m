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

@interface SelectFamilyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableFamily;
}
@property (nonatomic,strong)NSMutableArray   *arr_members;

@end

@implementation SelectFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"我的成员";
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
    
    self.arr_members = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        MemberEntity *entity = [[MemberEntity alloc]init];
        entity.name = @"豆豆";
        entity.phoneNum = @"18600000000";
        entity.IdCard = @"2222222222222222";
        entity.age = @"13";
        entity.gender = @"男";
        [self.arr_members addObject:entity];
    }
    [self addTableView];
}

-(void)addTableView{
    
    tableFamily = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 72 * 3 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableFamily];
    [tableFamily setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    tableFamily.delegate = self;
    tableFamily.dataSource = self;
    tableFamily.rowHeight = 72;
    tableFamily.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableFamily registerClass:[FamileTableViewCell class] forCellReuseIdentifier:@"tableView"];
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
    [cell.lab_name setText:entity.name];
    [cell.lab_sexAndphoneNum setText:entity.phoneNum];
    [cell.lab_IDCard setText:[NSString stringWithFormat:@"身份证号: %@",entity.IdCard]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberEntity *entity = [self.arr_members objectAtIndex:indexPath.row];
    [self.delegate didSelectedMemberWithEntity:entity];
    [self.navigationController popViewControllerAnimated:YES];
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
