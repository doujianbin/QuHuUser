//
//  PatientDetailViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "PatientDetailTableViewCell.h"
#import "PatientDetailEntity.h"
#import "PatientPictureView.h"
#import "EditPatientViewController.h"
#import "PuTongPZViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "Toast+UIView.h"
#import "ShowBigPhotosViewController.h"
#import "NSString+Size.h"

@interface PatientDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PatientPictureViewDelegate,EditPatientViewControllerDelegate>
@property (nonatomic )int pageNo;
@property (nonatomic ,strong)UITableView *tb_patientDetail;
@property (nonatomic ,strong)NSMutableArray *arr_patientDetail;
@property (nonatomic ,strong)UIView *tab_backGroundView;
@property (nonatomic ,assign)int  int_selectedIndex;

@end

@implementation PatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.title = [NSString stringWithFormat:@"%@的档案",self.patientEntity.userName];
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    [self onCteate];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)refreshDataWithPatientDetailEntity:(PatientDetailEntity *)entity{
    [self.arr_patientDetail replaceObjectAtIndex:self.int_selectedIndex withObject:entity];
    [self.tb_patientDetail reloadData];
}

-(void)loadData{
    self.pageNo = 1;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetPatientRecordsByPage];
    NSString *pageNo = [NSString stringWithFormat:@"%d",self.pageNo];
    NSDictionary *dic = @{@"pageNo":pageNo,@"patientId":self.patientEntity.userId};
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            NSArray *arr = [responseDic objectForKey:@"data"];
            self.arr_patientDetail = [NSMutableArray arrayWithArray:[PatientDetailEntity parsePatientDetailEntityArrayWithJson:[responseDic objectForKey:@"data"]]];
            [self.tb_patientDetail reloadData];
            if (arr.count > 0) {
                [self.tb_patientDetail setBackgroundView:nil];
                self.pageNo++;
            }else{
                [self.tb_patientDetail setBackgroundView:self.tab_backGroundView];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)onCteate{
    self.tb_patientDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tb_patientDetail];
    self.tb_patientDetail.delegate = self;
    self.tb_patientDetail.dataSource = self;
    self.tb_patientDetail.separatorColor = [UIColor clearColor];
    self.tb_patientDetail.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.tb_patientDetail.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerLoadData];
    }];
    
    self.tab_backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tb_patientDetail.frame.size.width, self.tb_patientDetail.frame.size.height)];
    UIImageView *img_nothing = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(SCREEN_WIDTH - 127)/2, 115, 127)];
    [self.tab_backGroundView addSubview:img_nothing];
    [img_nothing setImage:[UIImage imageNamed:@"nothingView"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img_nothing.frame) + 20 , SCREEN_WIDTH, 20)];
    [self.tab_backGroundView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您还没有档案记录哦~"];
    
    UIButton *btn_yuyue = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, CGRectGetMaxY(lab.frame) + 10, 120, 28)];
    [self.tab_backGroundView addSubview:btn_yuyue];
    [btn_yuyue setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
    btn_yuyue.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn_yuyue setTitle:@"预约陪诊服务" forState:UIControlStateNormal];
    btn_yuyue.layer.cornerRadius = 3.0;
    btn_yuyue.layer.masksToBounds = YES;
    [btn_yuyue addTarget:self action:@selector(btnyuyueAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)footerLoadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetPatientRecordsByPage];
    NSString *pageNo = [NSString stringWithFormat:@"%d",self.pageNo];
    NSDictionary *dic = @{@"pageNo":pageNo,@"patientId":self.patientEntity.userId};
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        
        if ([Status isEqualToString:SUCCESS]) {
            NSArray *arr = [responseDic objectForKey:@"data"];
            [self.arr_patientDetail addObjectsFromArray:[PatientDetailEntity parsePatientDetailEntityArrayWithJson:[responseDic objectForKey:@"data"]]];
            [self.tb_patientDetail reloadData];
            if (arr.count > 0) {
                [self.tb_patientDetail setBackgroundView:nil];
                self.pageNo++;
                [self.tb_patientDetail.mj_footer endRefreshing];
            }else{
                [self.tb_patientDetail.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } fail:^(NSError *error) {
        [self.tb_patientDetail.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientDetailEntity *patientDetailEntity = [self.arr_patientDetail objectAtIndex:indexPath.section];
    PatientListTotalView *v_demo = [[PatientListTotalView alloc]init];
    NSString *time = [patientDetailEntity.serviceTime substringToIndex:16];
    NSString *str_timeAndHospital = [NSString stringWithFormat:@"%@  %@",time, patientDetailEntity.hospitalName];
    CGFloat  height = [str_timeAndHospital fittingLabelHeightWithWidth:SCREEN_WIDTH - 20 - 30 andFontSize:[UIFont systemFontOfSize:17]];
    [v_demo setLabelText:patientDetailEntity.doctorName.length?patientDetailEntity.doctorName:@"医生" withOrifinY:0];
    CGFloat  h_doctorName = v_demo.frame.size.height;
    [v_demo setLabelText:patientDetailEntity.deptName.length?patientDetailEntity.deptName:@"科室" withOrifinY:0];
    CGFloat  h_department = v_demo.frame.size.height;
    [v_demo setLabelText:patientDetailEntity.diagnosis.length?patientDetailEntity.diagnosis:@"诊断" withOrifinY:0];
    CGFloat  h_diagnosis = v_demo.frame.size.height;
    [v_demo setLabelText:patientDetailEntity.diseaseDescription.length?patientDetailEntity.diseaseDescription:@"病情描述" withOrifinY:0];
    CGFloat  h_diseaseDescription = v_demo.frame.size.height;
    PatientPictureView *v_picture = [[PatientPictureView alloc]init];
    [v_picture loadCollectionViewWithPicturesArray:patientDetailEntity.pics withOrifinY:0];
    CGFloat  h_picture = v_picture.frame.size.height;
    return height + 24 + h_doctorName + h_department + h_diagnosis + h_diseaseDescription + h_picture;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_patientDetail.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PatientDetailCell";
    PatientDetailTableViewCell *cell = (PatientDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[PatientDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PatientDetailEntity *entity = [self.arr_patientDetail objectAtIndex:indexPath.section];
    cell.v_picture.delegate = self;
    cell.v_picture.collectionView.tag = indexPath.section;
    [cell contentCellVWithPatientDetailEntity:entity];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.int_selectedIndex = (int)indexPath.section;
    PatientDetailEntity *patientDetailEntity = [self.arr_patientDetail objectAtIndex:indexPath.section];
    EditPatientViewController *vc = [[EditPatientViewController alloc]init];
    vc.delegate = self;
    vc.entity = patientDetailEntity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectedWithIndex:(int)index withSection:(int)section{
    PatientDetailEntity *entity = [self.arr_patientDetail objectAtIndex:section];
    ShowBigPhotosViewController *vc = [[ShowBigPhotosViewController alloc]init];
    vc.arr_images = [NSMutableArray arrayWithArray:entity.pics];
    
    vc.int_index = index;
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64);
    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}

-(void)btnyuyueAction{
    PuTongPZViewController *pt = [[PuTongPZViewController alloc]init];
    pt.entity = self.patientEntity;
    pt.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pt animated:YES];
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
