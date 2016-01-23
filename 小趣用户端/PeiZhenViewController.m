//
//  PeiZhenViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PeiZhenViewController.h"
#import "HospitalTableViewCell.h"
#import "PuTongPZViewController.h"
#import "SelectDoctorViewController.h"
#import "HospitalViewController.h"
#import "SignInViewController.h"
#import "KDCycleBannerView.h"
#import "BannerWebViewController.h"

@interface PeiZhenViewController ()<UITableViewDataSource,UITableViewDelegate,KDCycleBannerViewDataource,KDCycleBannerViewDelegate>{
    UIButton *btn_putong;
    UIButton *btn_texu;
    UITableView *tableView_hospital;
    UIScrollView *scl_back;
    NSMutableArray *arr_hospital;
    NSMutableArray *arr_department;
    NSMutableArray *arr_bannerImg;
    NSMutableArray *arr_bannerLink;
    UIView         *sec;
    UIView         *view_keshi;
}
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)KDCycleBannerView *cycleBannerView;
@end

@implementation PeiZhenViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arr_hospital = [[NSMutableArray alloc]init];
        arr_department = [[NSMutableArray alloc]init];
        arr_bannerImg = [NSMutableArray array];
        arr_bannerLink = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    // Do any additional setup after loading the view.
    scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -5, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [self.view addSubview:scl_back];
    
    [self getMsg];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAgainAction) name:@"loginAgain" object:nil];
}

- (void)getMsg{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetShouYeMsg];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
        NSLog(@"首页信息＝%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            [LoginStorage saveCommonOrderDic:[[responseDic objectForKey:@"data"] objectForKey:@"commonSet"]];
            [LoginStorage saveSpecialOrderDic:[[responseDic objectForKey:@"data"] objectForKey:@"specialSet"]];
            arr_hospital = [[responseDic objectForKey:@"data"] objectForKey:@"hospitalList"];
            [tableView_hospital reloadData];
            arr_department = [[responseDic objectForKey:@"data"] objectForKey:@"deptList"];
            NSArray *arr = [[responseDic objectForKey:@"data"]objectForKey:@"pagePicList"];
            [arr_bannerImg removeAllObjects];
            [arr_bannerLink removeAllObjects];
            for (NSDictionary *dic in arr) {
                if ([[dic objectForKey:@"imgUrl"] length] == 0) {
                    [arr_bannerImg addObject:@""];
                }else{
                    [arr_bannerImg addObject:[dic objectForKey:@"imgUrl"]];
                }
                if ([[dic objectForKey:@"linkPath"] length] == 0) {
                    [arr_bannerLink addObject:@""];
                }else{
                    [arr_bannerLink addObject:[dic objectForKey:@"linkPath"]];
                }
            }
        }
        [self addMidView];
        [self addKeshiView];
        [self addYiYuanView];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(arr_bannerImg.count == 0){
        [self getMsg];
    }
    [self.cycleBannerView startAutoSwitchBannerView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.cycleBannerView cancelAutoSwitchBannerView];
}

// 中间普通陪诊和特需陪诊两个按钮
-(void)addMidView{
    self.cycleBannerView = [KDCycleBannerView new];
    self.cycleBannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / 320 * 245);
    self.cycleBannerView.delegate = self;
    self.cycleBannerView.datasource = self;
    self.cycleBannerView.continuous = YES;
    self.cycleBannerView.autoPlayTimeInterval = 5;
    [scl_back addSubview:self.cycleBannerView];
    
    UILabel *lb_place = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, 34, 18)];
    [lb_place setFont:[UIFont systemFontOfSize:17]];
    [lb_place setText:@"北京"];
    [lb_place setTextColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [scl_back addSubview:lb_place];
    
    UIImage *im_down = [UIImage imageNamed:@"Oval 21"];
    UIImageView *iv_down = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb_place.frame) + 5, 39.5, im_down.size.width, im_down.size.height)];
    [iv_down setImage:im_down];
    [scl_back addSubview:iv_down];
    
    sec = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleBannerView.frame), SCREEN_WIDTH, 95)];
    [scl_back addSubview:sec];
    [sec setBackgroundColor:[UIColor whiteColor]];
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 94.5, SCREEN_WIDTH, 0.5)];
    [sec addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    btn_putong = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 95)];
    [sec addSubview:btn_putong];
    [btn_putong addTarget:self action:@selector(btn_putongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img_putong = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22, 51 * SCREEN_WIDTH/375, 51 * SCREEN_WIDTH/375)];
    [btn_putong addSubview:img_putong];
    [img_putong setImage:[UIImage imageNamed:@"Oval 50 + Oval-52 + Shape"]];
    
    UILabel *lab_putong = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_putong.frame) + 5,30, 68, 18)];
    [btn_putong addSubview:lab_putong];
    [lab_putong setText:@"普通陪诊"];
    lab_putong.font = [UIFont systemFontOfSize:17];
    [lab_putong setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UILabel *lab_putong2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_putong.frame) + 5, 53, 84, 12.5)];
    [btn_putong addSubview:lab_putong2];
    [lab_putong2 setText:@"挂号排队一条龙"];
    lab_putong2.font = [UIFont systemFontOfSize:12];
    [lab_putong2 setTextColor:[UIColor colorWithHexString:@"4A4A4A" alpha:0.5]];
    
    UIImageView *img_shu = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, 0.5, 95)];
    [sec addSubview:img_shu];
    [img_shu setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    
    btn_texu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 95)];
    [sec addSubview:btn_texu];
    [btn_texu addTarget:self action:@selector(btn_texuAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img_texu = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22,  51 * SCREEN_WIDTH/375,  51 * SCREEN_WIDTH/375)];
    [btn_texu addSubview:img_texu];
    [img_texu setImage:[UIImage imageNamed:@"Oval 50 Copy + Group"]];
    
    UILabel *lab_texu = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_texu.frame) + 5, 30, 68, 18)];
    [btn_texu addSubview:lab_texu];
    [lab_texu setText:@"特需陪诊"];
    lab_texu.font = [UIFont systemFontOfSize:17];
    [lab_texu setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UILabel *lab_texu2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_texu.frame) + 5, 53, 84, 12.5)];
    [btn_texu addSubview:lab_texu2];
    [lab_texu2 setText:@"妥妥专家号预约"];
    lab_texu2.font = [UIFont systemFontOfSize:12];
    [lab_texu2 setTextColor:[UIColor colorWithHexString:@"4A4A4A" alpha:0.5]];
    
}

-(void)addKeshiView{
    
    UIButton *btn_allkeshi = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sec.frame) + 10, SCREEN_WIDTH, 40)];
    [scl_back addSubview:btn_allkeshi];
    [btn_allkeshi setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12.5, 2, 17)];
    [btn_allkeshi addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"Rectangle 39"]];
    
    UILabel *lab_allkeshi = [[UILabel alloc]initWithFrame:CGRectMake(15, 12.5, 52, 14.5)];
    [btn_allkeshi addSubview:lab_allkeshi];
    [lab_allkeshi setText:@"热门科室"];
    lab_allkeshi.font = [UIFont systemFontOfSize:13];
    [lab_allkeshi setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    //    UIImageView *img_jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 21, 15, 6, 10)];
    //    [btn_allkeshi addSubview:img_jiantou];
    //    [img_jiantou setImage:[UIImage imageNamed:@"Path 3"]];
    
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    [btn_allkeshi addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    view_keshi = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(btn_allkeshi.frame), SCREEN_WIDTH, 80)];
    [scl_back addSubview:view_keshi];
    [view_keshi setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat  width_btn = 51.0;
    UIView *v_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 14.5*2 + width_btn)];
    [view_keshi addSubview:v_back];
    NSMutableArray *arr_btnTitle = [NSMutableArray array];
    for (int i= 0;i < arr_department.count;i ++) {
        NSDictionary *dic =[arr_department objectAtIndex:i];
        if (i < 4) {
            [arr_btnTitle addObject:[dic objectForKey:@"deptName"]];
        }
    }
    NSArray *arr_btnColor = @[@"#D1A9EF",@"#C2E184",@"#A1CAF6",@"#FCB8AF"];
    CGFloat  width_space = (self.view.frame.size.width - (width_btn * arr_btnTitle.count))/(arr_btnTitle.count + 1);
    for (int i = 0; i < arr_btnTitle.count; i++) {
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake((i + 1) * width_space + i * width_btn,14.5, width_btn, width_btn)];
        [btn.layer setCornerRadius:width_btn / 2];
        [btn setTitle:[arr_btnTitle objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:[arr_btnColor objectAtIndex:i]]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [v_back addSubview:btn];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btn_keshiAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addYiYuanView{
    UIButton *btn_allyiyuan = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view_keshi.frame) + 10, SCREEN_WIDTH, 40)];
    [scl_back addSubview:btn_allyiyuan];
    [btn_allyiyuan setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12.5, 2, 17)];
    [btn_allyiyuan addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"Rectangle 39"]];
    
    UILabel *lab_allyiyuan = [[UILabel alloc]initWithFrame:CGRectMake(15, 12.5, 52, 14.5)];
    [btn_allyiyuan addSubview:lab_allyiyuan];
    [lab_allyiyuan setText:@"热门医院"];
    lab_allyiyuan.font = [UIFont systemFontOfSize:13];
    [lab_allyiyuan setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    [btn_allyiyuan addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    //    UIImageView *img_jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 21, 15, 6, 10)];
    //    [btn_allyiyuan addSubview:img_jiantou];
    //    [img_jiantou setImage:[UIImage imageNamed:@"Path 3"]];
    //
    tableView_hospital = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(btn_allyiyuan.frame), SCREEN_WIDTH, 72 * arr_hospital.count) style:UITableViewStylePlain];
    [scl_back addSubview:tableView_hospital];
    [tableView_hospital setBackgroundColor:[UIColor whiteColor]];
    [tableView_hospital setDataSource:self];
    [tableView_hospital setDelegate:self];
    [tableView_hospital setRowHeight:72];
    [tableView_hospital registerClass:[HospitalTableViewCell class] forCellReuseIdentifier:@"tableViewHospital"];
    tableView_hospital.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(tableView_hospital.frame) + 10)];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_hospital.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewHospital"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell.lab_hospital setText:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"hospitalName"]];
    [cell.lab_hospitalAddress setText:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"address"]];
    //    [cell.lab_juli setText:@"1.3KM"];
    //    NSString *picUrl = [[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"picUrl"];
    //    if (![picUrl isKindOfClass:[NSNull class]]) {
    //
    //        [cell.img_hospitalPic setImageWithURL:[NSURL URLWithString:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:nil];
    //    }
    [cell.img_hospitalPic sd_setImageWithURL:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"picUrl"] placeholderImage:[UIImage imageNamed:@"placeHolderChang"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---------");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HospitalViewController *hospitalView = [[HospitalViewController alloc]init];
    hospitalView.dic_hospital = [arr_hospital objectAtIndex:indexPath.row];
    UINavigationController *nav_hospital = [[UINavigationController alloc]initWithRootViewController:hospitalView];
    [self presentViewController:nav_hospital animated:YES completion:nil];
}

-(void)btn_putongAction{
    NSLog(@"普通陪诊");
    PuTongPZViewController *pt = [[PuTongPZViewController alloc]init];
    UINavigationController *nav_pt = [[UINavigationController alloc]initWithRootViewController:pt];
    [self presentViewController:nav_pt animated:YES completion:nil];
}

-(void)btn_texuAction{
    NSLog(@"特需陪诊");
    SelectDoctorViewController *selectDoctor = [[SelectDoctorViewController alloc]init];
    UINavigationController *nnav_Sd = [[UINavigationController alloc]initWithRootViewController:selectDoctor];
    [self presentViewController:nnav_Sd animated:YES completion:nil];
}

-(void)btn_keshiAction:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    SelectDoctorViewController *vc = [[SelectDoctorViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.str_selectedType = sender.titleLabel.text;
    //    vc.hidesBottomBarWhenPushed = YES;//隐藏tabbar
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)loginAgainAction{
    SignInViewController *sign = [[SignInViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sign];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    return arr_bannerImg;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFit;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"img_cyclebanner"];
}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
    //    NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
    if([[arr_bannerLink objectAtIndex:index] length] > 0){
        BannerWebViewController *vc = [[BannerWebViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.str_url = [arr_bannerLink objectAtIndex:index];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
