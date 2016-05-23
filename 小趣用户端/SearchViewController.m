//
//  SearchViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SearchViewController.h"
#import "MapHospitalTableViewCell.h"
#import "HospitalInMapEntity.h"
#import "PuTongPZViewController.h"
#import "PuTongPZViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)UISearchBar *mysearchbar;
@property (nonatomic, retain)UITableView *tab_search;
@property (nonatomic, retain)NSMutableArray *arr_search;
@property (nonatomic, retain)NSString *searchText;
@property (nonatomic, retain)UIView *tab_backGroudView;

@end

@implementation SearchViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_search = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)loadView {
    [super loadView];
    [self addSearchBar];
    [self addTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 0, 0)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    UIButton *btnr = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0, 34, 40)];
    [btnr setTitle:@"取消" forState:UIControlStateNormal];
    [btnr setTitleColor:[UIColor colorWithHexString:@"#fa6262"] forState:UIControlStateNormal];
    btnr.titleLabel.font = [UIFont systemFontOfSize:17];
    btnr.titleLabel.textAlignment = NSTextAlignmentRight;
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc]initWithCustomView:btnr];
    self.navigationItem.rightBarButtonItem = btnRight;
    [btnr addTarget:self action:@selector(btnRAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,QueryHospital];
    NSDictionary *dic = @{@"keyword":self.searchText,@"cityId":@"110100"};
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            [self.arr_search removeAllObjects];
            NSArray *arr = [HospitalInMapEntity parseHospitalInMapWithJson:[responseDic objectForKey:@"data"]];
            if (arr.count == 0) {
                [self.tab_search setBackgroundView:self.tab_backGroudView];
            }else{
                
                for (NSDictionary *dic in arr) {
                    [self.arr_search addObject:dic];
                }
                [self.tab_search reloadData];
            }
           
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)addSearchBar{
    self.mysearchbar = [[UISearchBar alloc] init];
    [self.mysearchbar setFrame:CGRectMake(0, 0,SCREEN_WIDTH - 34, 0)];
    [_mysearchbar setPlaceholder:@"搜索地点"];
    _mysearchbar.delegate = self;
    [_mysearchbar becomeFirstResponder];
    self.navigationItem.titleView = _mysearchbar;
}

-(void)addTableView{
    self.tab_search = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 216 - 64 - 44) style:UITableViewStylePlain];
    [self.view addSubview:self.tab_search];
    [self.tab_search setDelegate:self];
    [self.tab_search setDataSource:self];
    [self.tab_search setRowHeight:66];
    [self.tab_search setSeparatorColor:[UIColor clearColor]];
    
    self.tab_backGroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 17)];
    [self.tab_backGroudView addSubview:lab];
    [lab setText:@"暂无数据"];
    [lab setTextColor:[UIColor colorWithHexString:@"#A4A4A4"]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setFont:[UIFont systemFontOfSize:17]];
}

#pragma mark TableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_search.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchTabViewCell";
    MapHospitalTableViewCell *cell = (MapHospitalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MapHospitalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    HospitalInMapEntity *entity = [self.arr_search objectAtIndex:indexPath.row];
    [cell contentCellWithEntity:entity];
    [cell.lab_distance setHidden:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.sourceFrom isEqualToString:@"1"]) {
        
        HospitalInMapEntity *entity = [self.arr_search objectAtIndex:indexPath.row];
        PuTongPZViewController *vc = [[PuTongPZViewController alloc]init];
        vc.str_hospitalId = [NSString stringWithFormat:@"%d",entity.hospitalId];
        vc.str_hospitalName = entity.name;
        vc.str_hospitalAddress = entity.address;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.sourceFrom isEqualToString:@"2"]) {
        
        HospitalInMapEntity *entity = [self.arr_search objectAtIndex:indexPath.row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self userInfo:dic];
//        
//        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PuTongPZViewController class]]) {
                //更新list数据
                [(PuTongPZViewController *)vc reloadTableViewFromSearchControllerWithEntity:entity];
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
}

#pragma mark -

// 输入地点触发search方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mysearchbar resignFirstResponder];
}

-(void)btnRAction{
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
