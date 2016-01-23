//
//  SelectDoctorViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SelectDoctorViewController.h"
#import "SelectDoctorTableViewCell.h"
#import "SelectTimeViewController.h"
#import "DoctorEntity.h"
#import "NSString+Size.h"

@interface SelectDoctorViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView      *leftTableView;
@property(nonatomic,strong)UITableView      *rightTableView;
@property(nonatomic,strong)NSMutableArray*     allSldData;
@property(nonatomic,strong)NSMutableArray*     fldData;
@property(nonatomic,strong)NSMutableArray*     sldData;
@property(nonatomic,strong)NSIndexPath* indexPath;

@property (nonatomic ,retain)AFNManager *manager;
@end

@implementation SelectDoctorViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.allSldData = [NSMutableArray array];
    self.fldData = [NSMutableArray array];
    self.sldData = [NSMutableArray array];
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self onCreate];
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    self.title = @"选择医院";
    
    [self.view addSubview:[UIView new]];
    
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 110, SCREEN_HEIGHT - 64)];
    [self.leftTableView setDelegate:self];
    [self.leftTableView setDataSource:self];
    [self.leftTableView setTableFooterView:[UIView new]];
    [self.leftTableView setSeparatorColor:[UIColor clearColor]];
    [self.leftTableView setBackgroundColor:[UIColor colorWithHexString:@"#F2F2F2"]];
    [self.view addSubview:self.leftTableView];
    
    self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(110, 64,SCREEN_WIDTH - 110, SCREEN_HEIGHT - 64)];
    [self.rightTableView setDelegate:self];
    [self.rightTableView setDataSource:self];
    [self.rightTableView setSeparatorColor:[UIColor clearColor]];
    [self.rightTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.rightTableView];
    
    [self loadData];
}

- (void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetDeptGroupDoctor];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
        NSLog(@"科室医生列表:%@",responseDic);
        for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
            NSString *deptName = [dic objectForKey:@"deptName"];
            if (deptName.length > 0) {
                [self.fldData addObject:deptName];
            }
            NSArray *arr = [DoctorEntity parseDoctorListWithJson:[dic objectForKey:@"doctorList"]];
            [self.allSldData addObject:arr];
        }
        [self.leftTableView reloadData];
        if (self.str_selectedType.length == 0 || ![self.fldData containsObject:self.str_selectedType]) {
            self.sldData = [self.allSldData firstObject];
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            for (int i = 0; i < self.fldData.count; i++) {
                if ([[self.fldData objectAtIndex:i] isEqualToString:self.str_selectedType]) {
                    self.sldData = [self.allSldData objectAtIndex:i];
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
        [self.rightTableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableView == tableView) {
        return 50;
    }
    return 91;
}

//设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.leftTableView == tableView) {
        return [self.fldData count];
    }else{
        return [self.sldData count];
    }
}
//每一行的内容为数组相应索引的值
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.leftTableView == tableView) {
        static NSString *CellIdentifier = @"fldCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectedBackgroundView;
        }
        cell.textLabel.text= [self.fldData objectAtIndex:indexPath.row];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"sldCell";
        
        SelectDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[SelectDoctorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        DoctorEntity  *doctorEntity = [self.sldData objectAtIndex:indexPath.row];
        cell.lab_name.text = doctorEntity.name;
        cell.lab_hospital.text = doctorEntity.hospitalName;
        cell.lab_zhicheng.text = doctorEntity.jobTitle;
        cell.lab_keshi.text = doctorEntity.deptName;
        [cell.imgPic sd_setImageWithURL:[NSURL URLWithString:doctorEntity.headPortraint] placeholderImage:nil];
        CGFloat width_name = [cell.lab_name.text fittingLabelWidthWithHeight:cell.lab_name.frame.size.height andFontSize:cell.lab_name.font];
        [cell.lab_name setFrame:CGRectMake(cell.lab_name.frame.origin.x, cell.lab_name.frame.origin.y, width_name, cell.lab_name.frame.size.height)];
        [cell.lab_zhicheng setFrame:CGRectMake(CGRectGetMaxX(cell.lab_name.frame) + 10, cell.lab_zhicheng.frame.origin.y, cell.lab_zhicheng.frame.size.width, cell.lab_zhicheng.frame.size.height)];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableView == tableView) {
        self.sldData = [self.allSldData objectAtIndex:indexPath.row];
        [self.rightTableView reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SelectTimeViewController *vc = [[SelectTimeViewController alloc]init];
        vc.doctorEntity = [self.sldData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)NavLeftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
