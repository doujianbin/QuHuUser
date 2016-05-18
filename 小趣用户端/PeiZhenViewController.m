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
#import "Toast+UIView.h"
#import "TalkingData.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import "MapAndHospitalViewController.h"
#import "NSString+Size.h"

#define MaxWidth SCREEN_WIDTH * 0.6

@interface PeiZhenViewController ()<UITableViewDataSource,UITableViewDelegate,KDCycleBannerViewDataource,KDCycleBannerViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIGestureRecognizerDelegate>{
    UIButton *btn_putong;
    UIButton *btn_texu;
    UITableView *tableView_hospital;
    UIScrollView *scl_back;
    NSMutableArray *arr_hospital;
    NSMutableArray *arr_department;
    NSMutableArray *arr_bannerImg;
    NSMutableArray *arr_bannerLink;
    NSMutableArray *arr_title;
    UIView         *sec;
    UIView         *view_keshi;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    
    
}
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)KDCycleBannerView *cycleBannerView;
@property (nonatomic ,strong)NSString *localCityName;
@property (nonatomic ,strong)UIButton *btn_navLeft;
@property (nonatomic ,strong)NSString *longitude;
@property (nonatomic ,strong)NSString *latitude;
@property (nonatomic ,strong)UILabel *lab_city;
@property (nonatomic ,strong)UIImageView *img_up;
@property (nonatomic ,strong)NSString *cityName;
@property (nonatomic )int currentCityServe;
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
        arr_title = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    UILabel *titleLabel = [[UILabel
                            alloc] initWithFrame:CGRectMake(0,
                                                            0, 150, 44)];
    [titleLabel setText:@"小趣好护士"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    self.navigationItem.titleView = titleLabel;
    
    self.btn_navLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 21.5, 60, 20)];
    self.lab_city = [[UILabel alloc]init];
    [self.btn_navLeft addSubview:self.lab_city];
    [self.lab_city setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    self.img_up = [[UIImageView alloc] init];
    [self.btn_navLeft addSubview:self.img_up];
    [self.img_up setImage:[UIImage imageNamed:@"下拉箭头"]];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:_btn_navLeft];
    self.navigationItem.leftBarButtonItem = btnleft;
    [_btn_navLeft addTarget:self action:@selector(selectLocationLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.

    scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -5, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [self.view addSubview:scl_back];
    
//    [self getMsg];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAgainAction) name:@"login" object:nil];
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            //初始化BMKLocationService
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            _locService.distanceFilter = 10000.0f;
            //启动LocationService
            [_locService startUserLocationService];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        // 定位功能不可用，提示用户或忽略引导用户开启
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位服务已关闭" message:@"请到设置－>隐私->定位服务中开启［小趣好护士］定位服务，以便为您提供更准确的服务信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.delegate = self;
        [alert show];
        self.longitude = @"0.0000";
        self.latitude = @"0.0000";
        [self getMsg];
    }
    
    
    //发起反向地理编码检索
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.961292, 116.466714};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
// 反地理编码检索 根据经纬度检索当前地理位置 城市
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
//    NSLog(@"这里是＝＝%@",result.addressDetail.city);
//    self.localCityName = result.addressDetail.city;
    
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    [self getMsg];
}


- (void)getMsg{
    
    BeginActivity;
    NSString *strUrl;
    if ([LoginStorage GetHTTPHeader] == nil) {
        strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/public/getHomePageInfoWithCity?longitude=%@&latitude=%@",Development,self.longitude,self.latitude];
    }else{
        strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/getHomePageInfoWithCity?longitude=%@&latitude=%@",Development,self.longitude,self.latitude];
    }
//    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/public/getHomePageInfoWithCity?longitude=%@&latitude=%@",Development,self.longitude,self.latitude];

    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
        NSLog(@"首页信息＝%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            EndActivity;
            //            [LoginStorage savePackageArr:[[responseDic objectForKey:@"data"] objectForKey:@"sets"]];
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
                if ([[dic objectForKey:@"linkPath"] isKindOfClass:[NSNull class]]) {
                    [arr_bannerLink addObject:@""];
                }else{
                    [arr_bannerLink addObject:[dic objectForKey:@"linkPath"]];
                }
                if ([[dic objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
                    [arr_title addObject:@"推广"];
                }else{
                    [arr_title addObject:[dic objectForKey:@"title"]];
                }
            }
            self.currentCityServe = [[[responseDic objectForKey:@"data"] objectForKey:@"currentCityServe"] intValue];
            if (self.currentCityServe == 0) {
                [self.view makeToast:Message duration:1.0 position:@"center"];
            }
            self.cityName = [[responseDic objectForKey:@"data"] objectForKey:@"cityName"];
            CGFloat width = [self.cityName fittingLabelWidthWithHeight:17 andFontSize:[UIFont systemFontOfSize:17]];
            [self.lab_city setFrame:CGRectMake(0, 1.5, width, 17)];
            NSString *strCN = [self.cityName substringToIndex:self.cityName.length - 1];
            [self.lab_city setText:strCN];
            [self.img_up setFrame:CGRectMake(CGRectGetMaxX(self.lab_city.frame) - 13, -2, 8, 20)];

        }
        [self addMidView];
        [self addYiYuanView];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        EndActivity;
        NetError;
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
    if(arr_bannerImg.count == 0){
//        [self getMsg];
    }
    [self.cycleBannerView startAutoSwitchBannerView];
}

- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
    [self.cycleBannerView cancelAutoSwitchBannerView];
}

// 中间普通陪诊和特需陪诊两个按钮
-(void)addMidView{
    self.cycleBannerView = [KDCycleBannerView new];
    self.cycleBannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT * 0.23);
    self.cycleBannerView.delegate = self;
    self.cycleBannerView.datasource = self;
    self.cycleBannerView.autoPlayTimeInterval = 5;
    [scl_back addSubview:self.cycleBannerView];
    if (arr_bannerImg.count > 1) {
        self.cycleBannerView.continuous = YES;
    }else{
        self.cycleBannerView.continuous = NO;
    }

    
    sec = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleBannerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT * 0.21)];
    [scl_back addSubview:sec];
    [sec setBackgroundColor:[UIColor whiteColor]];
    

    UIImageView *img_shu = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, 0.5, SCREEN_HEIGHT * 0.21)];
    [sec addSubview:img_shu];
    [img_shu setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, sec.frame.size.height / 2, SCREEN_WIDTH / 2, 0.5)];
    [sec addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIButton *btn_yuyueguahao = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, sec.frame.size.width / 2, sec.frame.size.height / 2)];
    [sec addSubview:btn_yuyueguahao];
    [btn_yuyueguahao addTarget:self action:@selector(btn_yuyueguahao) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.096, (sec.frame.size.height / 2 - 46) / 2, 46, 46)];
    [btn_yuyueguahao addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"挂号icon"]];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img1.frame) + 10, 0, 60, btn_yuyueguahao.frame.size.height)];
    [btn_yuyueguahao addSubview:lab1];
    [lab1 setText:@"预约挂号"];
    [lab1 setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    lab1.font = [UIFont systemFontOfSize:15];
    
    
    
    
    UIButton *btn_nearHospital = [[UIButton alloc]initWithFrame:CGRectMake(0, sec.frame.size.height / 2, sec.frame.size.width / 2, sec.frame.size.height / 2)];
    [sec addSubview:btn_nearHospital];
    [btn_nearHospital addTarget:self action:@selector(btn_nearHospital) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.096, (sec.frame.size.height / 2 - 46) / 2, 46, 46)];
    [btn_nearHospital addSubview:img2];
    [img2 setImage:[UIImage imageNamed:@"附近医院"]];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img1.frame) + 10, 0, 60, btn_nearHospital.frame.size.height)];
    [btn_nearHospital addSubview:lab2];
    [lab2 setText:@"附近医院"];
    [lab2 setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    lab2.font = [UIFont systemFontOfSize:15];
    
    
    

    UIButton *btn_yuYuePeiZhen = [[UIButton alloc]initWithFrame:CGRectMake(sec.frame.size.width / 2, 0, sec.frame.size.width / 2, sec.frame.size.height)];
    [sec addSubview:btn_yuYuePeiZhen];
    [btn_yuYuePeiZhen addTarget:self action:@selector(btn_yuYuePeiZhen) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *img3 = [[UIImageView alloc]initWithFrame:CGRectMake((sec.frame.size.width / 2 - 73) / 2 , 20, 73, 73)];
    [btn_yuYuePeiZhen addSubview:img3];
    [img3 setImage:[UIImage imageNamed:@"陪诊icon"]];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img3.frame) + 10, sec.frame.size.width / 2, 17)];
    [btn_yuYuePeiZhen addSubview:lab3];
    [lab3 setText:@"预约陪诊"];
    [lab3 setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    lab3.font = [UIFont systemFontOfSize:17];
    lab3.textAlignment = NSTextAlignmentCenter;
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

    CGFloat  width_space = (self.view.frame.size.width - (width_btn * arr_btnTitle.count))/(arr_btnTitle.count + 1);
    for (int i = 0; i < arr_btnTitle.count; i++) {
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake((i + 1) * width_space + i * width_btn,14.5, width_btn, width_btn)];
        [btn.layer setCornerRadius:width_btn / 2];
        [btn setTitle:[arr_btnTitle objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#FA6262" alpha:0.1]];
        btn.layer.borderWidth = 1.5;
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#FA6262" alpha:0.3] CGColor];
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [v_back addSubview:btn];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btn_keshiAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addYiYuanView{
    UIButton *btn_allyiyuan = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sec.frame) + 10, SCREEN_WIDTH, 40)];
    [scl_back addSubview:btn_allyiyuan];
    [btn_allyiyuan setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12.5, 2, 17)];
    [btn_allyiyuan addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"Rectangle 39"]];
    
    UILabel *lab_allyiyuan = [[UILabel alloc]initWithFrame:CGRectMake(15, 12.5, 52, 14.5)];
    [btn_allyiyuan addSubview:lab_allyiyuan];
    [lab_allyiyuan setText:@"热门医院"];
    lab_allyiyuan.font = [UIFont systemFontOfSize:13];
    [lab_allyiyuan setTextColor:[UIColor colorWithHexString:@"#A4A4A4"]];
    
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    [btn_allyiyuan addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    

    tableView_hospital = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(btn_allyiyuan.frame), SCREEN_WIDTH, 72 * arr_hospital.count) style:UITableViewStylePlain];
    [scl_back addSubview:tableView_hospital];
    [tableView_hospital setBackgroundColor:[UIColor whiteColor]];
    [tableView_hospital setDataSource:self];
    [tableView_hospital setDelegate:self];
    [tableView_hospital setRowHeight:72];
    [tableView_hospital registerClass:[HospitalTableViewCell class] forCellReuseIdentifier:@"tableViewHospital"];
    tableView_hospital.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(tableView_hospital.frame) - 20)];
    
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
    NSString *hn = [[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"hospitalName"];
    CGFloat width = [hn fittingLabelWidthWithHeight:18 andFontSize:[UIFont systemFontOfSize:17]];
    if (width < MaxWidth) {
        [cell.lab_hospital setFrame:CGRectMake(103.5, 15.5, width, 17)];
        [cell.lab_level setFrame:CGRectMake(CGRectGetMaxX(cell.lab_hospital.frame) + 10, 16, 27, 16)];
    }else{
        [cell.lab_hospital setFrame:CGRectMake(103.5, 15.5, MaxWidth, 17)];
        [cell.lab_level setFrame:CGRectMake(CGRectGetMaxX(cell.lab_hospital.frame) + 10, 16, 27, 16)];
    }
    [cell.lab_level setText:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"level"]];
    [cell.lab_hospital setText:hn];
    [cell.lab_hospitalAddress setText:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"address"]];
    [cell.img_hospitalPic sd_setImageWithURL:[[arr_hospital objectAtIndex:indexPath.row] objectForKey:@"picUrl"] placeholderImage:[UIImage imageNamed:@"mid"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---------");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HospitalViewController *hospitalView = [[HospitalViewController alloc]init];
    hospitalView.dic_hospital = [arr_hospital objectAtIndex:indexPath.row];
//    UINavigationController *nav_hospital = [[UINavigationController alloc]initWithRootViewController:hospitalView];
    hospitalView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hospitalView animated:YES];
}


//-(void)btn_texuAction{
//    NSLog(@"特需陪诊");
//    SelectDoctorViewController *selectDoctor = [[SelectDoctorViewController alloc]init];
////    UINavigationController *nnav_Sd = [[UINavigationController alloc]initWithRootViewController:selectDoctor];
//    selectDoctor.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:selectDoctor animated:YES];
//}

-(void)btn_keshiAction:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    SelectDoctorViewController *vc = [[SelectDoctorViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.str_selectedType = sender.titleLabel.text;
    vc.hidesBottomBarWhenPushed = YES;//隐藏tabbar
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loginAgainAction{
    SignInViewController *sign = [[SignInViewController alloc]init];
    sign.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sign animated:YES];
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
        vc.str_url = [arr_bannerLink objectAtIndex:index];
        vc.strTitle = [arr_title objectAtIndex:index];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//-(void)NavRightAction{
//    MapAndHospitalViewController *vc = [[MapAndHospitalViewController alloc]init];
//    vc.enterFirstCityName = self.localCityName;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)btn_yuyueguahao{
    
}

-(void)btn_nearHospital{
    MapAndHospitalViewController *vc = [[MapAndHospitalViewController alloc]init];
    vc.enterFirstCityName = self.cityName;
    vc.currentCityServe = self.currentCityServe;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btn_yuYuePeiZhen{
    [TalkingData trackEvent:@"用户点击陪诊按钮"];
    PuTongPZViewController *pt = [[PuTongPZViewController alloc]init];
    //    UINavigationController *nav_pt = [[UINavigationController alloc]initWithRootViewController:pt];
    pt.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pt animated:YES];
}

-(void)selectLocationLeftAction{
    
}

@end
