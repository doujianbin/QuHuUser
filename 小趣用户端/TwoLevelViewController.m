//
//  TwoLevelViewController.m
//  juliye-iphone
//
//  Created by lixiao on 16/1/11.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "TwoLevelViewController.h"
#import "BaseTwoLevelView.h"
#import "RightTableViewCell.h"
@interface TwoLevelViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderTableViewDataSource,HeaderTableViewDelegate>

@property(nonatomic,strong)BaseTwoLevelView *rootView;
@property(nonatomic,strong)NSArray*     allSldData;
@property(nonatomic,strong)NSArray*     fldData;
@property(nonatomic,strong)NSArray*     sldData;
@property(nonatomic,strong)NSIndexPath* indexPath;
@property(nonatomic ,retain)AFNManager *manager;

@end

@implementation TwoLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.rootView = [[BaseTwoLevelView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    self.rootView.headerTableView.dataSource = self;
    self.rootView.headerTableView.delegate = self;
    self.rootView.rightTabelView.dataSource = self;
    self.rootView.rightTabelView.delegate = self;
    self.rootView.headerTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootView];
    [self loadData];
}

- (void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,AreaForHospital];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
        NSLog(@"区域医院:%@",responseDic);
    } fail:^(NSError *error) {
        NSLog(@"error=%ld",(long)error.code);
        NSLog(@"%@",error.domain);
        NSLog(@"%@",error.userInfo);
        
    }];
    self.fldData = @[@"赵扬区",@"钱扬区",@"孙扬区",@"李扬区",@"周扬区",@"吴扬区",@"郑扬区",@"王扬区"];
    self.allSldData = @[@[@"赵晓豆",@"赵晓豆",@"赵晓豆",@"赵晓豆",@"赵晓豆"],@[@"钱小豆",@"钱小豆",@"钱小豆",@"钱小豆",@"钱小豆"],@[@"孙晓豆",@"孙晓豆",@"孙晓豆",@"孙晓豆",@"孙晓豆"],@[@"李晓豆",@"李晓豆",@"李晓豆",@"李晓豆",@"李晓豆"],@[@"周小豆",@"周小豆",@"周小豆",@"周小豆",@"周小豆"],@[@"吴晓豆",@"吴晓豆",@"吴晓豆",@"吴晓豆",@"吴晓豆"],@[@"郑小豆",@"郑小豆",@"郑小豆",@"郑小豆",@"郑小豆"],@[@"王晓豆",@"王晓豆",@"王晓豆",@"王晓豆",@"王晓豆"]];
    self.sldData = [self.allSldData firstObject];
    [self.rootView.headerTableView reloadData];
}

- (NSString*)tableView:(UITableView *)tableView headerTitleForForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fldData objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rootView.rightTabelView != tableView) {
        return 50;
    }
    return 60;
}

//设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rootView.rightTabelView != tableView) {
        return [self.fldData count];
    }else{
        return [self.sldData count];
    }
}
//每一行的内容为数组相应索引的值
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.rootView.rightTabelView != tableView) {
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
        
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.lab_hospitalName.text= [self.sldData objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rootView.rightTabelView != tableView) {
        self.sldData = [self.allSldData objectAtIndex:indexPath.row];
        [self.rootView.rightTabelView reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
