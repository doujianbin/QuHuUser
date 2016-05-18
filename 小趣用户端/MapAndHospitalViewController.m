//
//  MapAndHospitalViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/6.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MapAndHospitalViewController.h"
#import "NSString+Size.h"
#import "Toast+UIView.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

#import "MycustomAnnotationView.h"
#import "MycustomActionPaopao.h"
#import "MapHospitalTableViewCell.h"
#import "SearchViewController.h"
#import "HospitalInMapEntity.h"
#import "PuTongPZViewController.h"

@interface MapAndHospitalViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>{
    BMKLocationService *_locService;
    BMKMapView *_mapView;
    BMKPointAnnotation* _myLocAnnotation;
    BMKGeoCodeSearch *_searcher;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
}
@property (nonatomic ,assign)CGFloat latitude;
@property (nonatomic ,assign)CGFloat longitude;
@property (nonatomic )int status;
@property (nonatomic ,strong)UIButton *btn_mylocation;
@property (nonatomic ,strong)UIImageView *mapCenterImg;
@property (nonatomic ,strong)NSMutableArray *arr_tableView;
@property (nonatomic ,strong)UITableView *tab_hospital;
@property (nonatomic ,strong)NSMutableArray *arr_annonation;
@property (nonatomic ,strong)NSString *str_location;
@property (nonatomic ,strong)NSMutableArray *annonation;  // 存放标注的数组

@property (nonatomic ,strong)UIImageView *img_search;
@property (nonatomic ,strong)UILabel *lab_searchCity;
@property (nonatomic ,strong)UIImageView *img_searchShu;
@property (nonatomic ,strong)UIImageView *img_searchIcon;
@property (nonatomic ,strong)UILabel *lab_search;
@property (nonatomic ,strong)UILabel *lab_localName;
@property (nonatomic ,strong)NSString *moveEndCityName;

@end

@implementation MapAndHospitalViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_tableView = [[NSMutableArray alloc]init];
        self.arr_annonation = [[NSMutableArray alloc]init];
        self.annonation = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self addMapView];
    [self addTableView];
    
    reverseGeoCodeSearchOption = [[
                                   BMKReverseGeoCodeOption alloc]init];
    //定位功能可用，开始定位
    [self IslocService];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"陪诊医院";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //初始化search 服务
            _searcher =[[BMKGeoCodeSearch alloc]init];
            _searcher.delegate = self;
        
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        // 定位功能不可用，提示用户或忽略引导用户开启
        NSString *str = @"北京市";
        CGFloat width = [str fittingLabelWidthWithHeight:16 andFontSize:[UIFont systemFontOfSize:16]];
        [_lab_searchCity setFrame:CGRectMake(16, 13, width, 16)];
        [_lab_searchCity setText:str];
        [_img_searchShu setFrame:CGRectMake(CGRectGetMaxX(_lab_searchCity.frame) + 10, 11, 1, 20)];
        _img_searchIcon.frame = CGRectMake(_img_search.frame.size.width / 2 - 35, 16, 13, 12);
        _lab_search.frame = CGRectMake(CGRectGetMaxX(_img_searchIcon.frame)+6, 14, 60, 14);
        [_lab_localName setText:@"无法获取您的位置，请重试"];
        [_mapCenterImg setHidden:YES];
        [_btn_mylocation setHidden:YES];
        [self loadData];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位服务已关闭" message:@"请到设置－>隐私->定位服务中开启［小趣好护士］定位服务，以便为您提供更准确的服务信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.delegate = self;
        [alert show];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
//    NSString *netStatus = [self getNetWorkStates];
//    if ([netStatus isEqualToString:@"3G"] || [netStatus isEqualToString:@"4G"] || [netStatus isEqualToString:@"wifi"]) {
//        // 网络状态正常
    

}

-(void)IslocService{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 500;
    //启动LocationService
    [_locService startUserLocationService];
}
# pragma BMKLocationServiceDelegate
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
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    // 定位成功
    [_mapCenterImg setHidden:NO];
    [_btn_mylocation setHidden:NO];
    //获取当前位置
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
    [self selectAddressFromCLLocation:pt];

    CLLocationCoordinate2D coor;
    coor.latitude = self.latitude;
    coor.longitude = self.longitude;
    [_mapView setCenterCoordinate:coor animated:YES];
//    CGPoint center = [_mapView convertCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) toPointToView:_mapView];
    CGPoint center = _mapView.center;
    center.y = center.y - 10;
    _mapCenterImg.center = center;
    
    //  根据经纬度拿数据
    [self loadData];
}
//定位失败走此协议方法
- (void)didFailToLocateUserWithError:(NSError *)error{
    // 定位失败
    
}
# pragma -


//- (NSString *)getNetWorkStates{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
//    NSString *state = [[NSString alloc]init];
//    int netType = 0;
//    //获取到网络返回码
//    for (id child in children) {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            //获取到状态栏
//            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//            
//            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    //无网模式
//                    break;
//                case 1:
//                    state =  @"2G";
//                    break;
//                case 2:
//                    state =  @"3G";
//                    break;
//                case 3:
//                    state =   @"4G";
//                    break;
//                case 5:
//                {
//                    state =  @"wifi";
//                    break;
//                default:
//                    break;
//                }
//            }
//        }
//        //根据状态选择
//    }
//    return state;
//}

-(void)addMapView{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 296)];
    [self.view addSubview:_mapView];
    
    // 放置我的位置的图片
    self.btn_mylocation = [[UIButton alloc]initWithFrame:CGRectMake(15, _mapView.frame.size.height - 45, 30, 30)];
    [_mapView addSubview:_btn_mylocation];

    [_btn_mylocation setBackgroundImage:[UIImage imageNamed:@"重置"] forState:UIControlStateNormal];
    [_btn_mylocation addTarget:self action:@selector(btn_mylocationAction) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView.zoomLevel = 17;
    _mapView.delegate = self;

    
    self.mapCenterImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_mapCenterImg setImage:[UIImage imageNamed:@"当前位置"]];
    [_mapView addSubview:_mapCenterImg];
    
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(puchSearchAction)];
    
    // 放上面的搜索条
    self.img_search = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 30, 45)];
    [_mapView addSubview:_img_search];
    [_img_search setImage:[UIImage imageNamed:@"搜索框"]];
    _img_search.userInteractionEnabled = YES;
    [_img_search addGestureRecognizer:tgp];
    
    self.lab_searchCity = [[UILabel alloc]init];
    [_img_search addSubview:_lab_searchCity];
    _lab_searchCity.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    _lab_searchCity.font = [UIFont systemFontOfSize:16];
    
    self.img_searchShu = [[UIImageView alloc]init];
    [_img_search addSubview:_img_searchShu];
    [_img_searchShu setBackgroundColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    self.img_searchIcon = [[UIImageView alloc]init];
    [_img_search addSubview:_img_searchIcon];
    [_img_searchIcon setImage:[UIImage imageNamed:@"搜索图标"]];
    
    self.lab_search = [[UILabel alloc]init];
    [_img_search addSubview:_lab_search];
    [_lab_search setText:@"搜索医院"];
    [_lab_search setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
    [_lab_search setFont:[UIFont systemFontOfSize:14]];
    
    CGFloat width = [self.enterFirstCityName fittingLabelWidthWithHeight:16 andFontSize:[UIFont systemFontOfSize:16]];
    [_lab_searchCity setFrame:CGRectMake(16, 13, width, 16)];
    [_lab_searchCity setText:self.enterFirstCityName];
    [_img_searchShu setFrame:CGRectMake(CGRectGetMaxX(_lab_searchCity.frame) + 10, 11, 1, 20)];
    _img_searchIcon.frame = CGRectMake(_img_search.frame.size.width / 2 - 35, 16, 13, 12);
    _lab_search.frame = CGRectMake(CGRectGetMaxX(_img_searchIcon.frame)+6, 14, 60, 14);
    
    [_lab_localName setText:self.enterFirstCityName];
    
}


//- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    // 移动前走这里
//    [_mapView removeAnnotations:self.arr_annonation];
//    
//}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //  移动结束后走此方法
    NSLog(@"didUpdateUserLocation lat %f,long %f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
    
    
    [UIView animateWithDuration:0.2f animations:^{
        CGPoint center = _mapCenterImg.center;
        center.y -= 20.0f;
        _mapCenterImg.center = center;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2f animations:^{
            CGPoint center = _mapCenterImg.center;
            center.y += 20.0f;
            _mapCenterImg.center = center;
            
        } completion:^(BOOL finished) {
            

        }];
        
    }];
//    [_mapView removeAnnotations:self.annonation];

    self.latitude = _mapView.centerCoordinate.latitude;
    self.longitude = _mapView.centerCoordinate.longitude;
    
    
    [self loadData];

    
    // 拿_mapView 下面tableView的数据
    // 通过经纬度 反查当前位置
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude};
    [self selectAddressFromCLLocation:pt];
}

-(void)selectAddressFromCLLocation:(CLLocationCoordinate2D )coor{
    CLLocationCoordinate2D pt = coor;
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
    if (self.currentCityServe == 1) {
        if (result.poiList.count > 0) {
            
            if (![result.addressDetail.city isEqualToString:self.enterFirstCityName]) {
                [self.view makeToast:@"您的位置已经移出北京啦" duration:1.0 position:@"center"];
            }
//                else{
//
                BMKPoiInfo *ingo = [result.poiList objectAtIndex:0];
//                //            NSLog(@"这里是＝＝%@",ingo.name);
//                CGFloat width = [result.addressDetail.city fittingLabelWidthWithHeight:16 andFontSize:[UIFont systemFontOfSize:16]];
//                [_lab_searchCity setFrame:CGRectMake(16, 13, width, 16)];
//                [_lab_searchCity setText:result.addressDetail.city];
//                [_img_searchShu setFrame:CGRectMake(CGRectGetMaxX(_lab_searchCity.frame) + 10, 11, 1, 20)];
//                _img_searchIcon.frame = CGRectMake(_img_search.frame.size.width / 2 - 35, 16, 13, 12);
//                _lab_search.frame = CGRectMake(CGRectGetMaxX(_img_searchIcon.frame)+6, 14, 60, 14);
//                
                [_lab_localName setText:ingo.name];
//            }
        }
    }
}

-(void)btn_mylocationAction{
    [self IslocService];
    _mapView.zoomLevel = 17;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) animated:YES];
}

-(void)loadData{
    
    [_mapView removeAnnotations:self.annonation];

    NSString *strUrl;
    if ([LoginStorage GetHTTPHeader] == nil) {
        strUrl = [NSString stringWithFormat:@"%@%@",Development,GetNearPublicByHospitalList];
    }else{
        strUrl = [NSString stringWithFormat:@"%@%@",Development,GetNearByHospitalList];
    }
//    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetNearByHospitalList];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.latitude];
    NSDictionary *dic = @{@"cityId":@"110100",@"longitude":longitude,@"latitude":latitude};
    
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            [self.annonation removeAllObjects];
            
            [self.arr_annonation removeAllObjects];
            [self.arr_tableView removeAllObjects];
            NSArray *arr_hot = [HospitalInMapEntity parseHospitalInMapWithJson:[[responseDic objectForKey:@"data"] objectForKey:@"hotHospitalList"]];
            NSArray *arr_near = [HospitalInMapEntity parseHospitalInMapWithJson:[[responseDic objectForKey:@"data"] objectForKey:@"nearByHospitalList"]];
            NSArray *arr_nearDic = [[responseDic objectForKey:@"data"] objectForKey:@"nearByHospitalList"];
            NSArray *arr_visit = [HospitalInMapEntity parseHospitalInMapWithJson:[[responseDic objectForKey:@"data"] objectForKey:@"visitedHospitalList"]];
            NSMutableArray *arr_hotLess = [[NSMutableArray alloc]init];
            //  处理地图上 Annotion的数据
            
            if (arr_nearDic.count > 0) {
                for (NSDictionary *dic in arr_nearDic) {
                    [self.arr_annonation addObject:dic];
                }
            }
              
            //  处理 tableview 的数据
            if (arr_near.count > 0) {
                for (NSDictionary *dic in arr_near) {
                    [arr_hotLess addObject:dic];
                }
            }
            if (arr_visit.count > 0) {
                for (NSDictionary *dic in arr_visit) {
                    [arr_hotLess addObject:dic];
                }
            }
            if (arr_hotLess.count > 0) {
                [self.arr_tableView addObject:arr_hotLess];
            }
            [self.arr_tableView addObject:arr_hot];
            [self.tab_hospital reloadData];
            
            for (NSDictionary *dic in self.arr_annonation) {
                
                BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude = [[dic objectForKey:@"latitude"] floatValue];
                coor.longitude = [[dic objectForKey:@"longitude"] floatValue];
                annotation.coordinate = coor;
                annotation.title = [dic objectForKey:@"name"];
                [self.annonation addObject:annotation];
            }
            
            [_mapView addAnnotations:self.annonation];
            
        }
    } fail:^(NSError *error) {
        
    }];

}

-(void)addTableView{
    
    UIView *view_title = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), SCREEN_WIDTH, 47)];
    [self.view addSubview:view_title];
    self.lab_localName = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, SCREEN_WIDTH - 30, 14)];
    [view_title addSubview:_lab_localName];
    [_lab_localName setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [_lab_localName setFont:[UIFont systemFontOfSize:14]];
    
    self.tab_hospital = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_title.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_mapView.frame) - 64 - 47) style:UITableViewStylePlain];
    [self.view addSubview:self.tab_hospital];
    self.tab_hospital.dataSource = self;
    self.tab_hospital.delegate = self;
    [self.tab_hospital setSeparatorColor:[UIColor clearColor]];
    
}

#pragma mapViewDelegate -

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.annotation=annotation;
        
        annotationView.image = [UIImage imageNamed:@"hospitalImg"];   //把大头针换成别的图片
        NSInteger a = [self.annonation indexOfObject:annotation];
        NSDictionary *dic = [self.arr_annonation objectAtIndex:a];

        CGFloat width = [[dic objectForKey:@"name"] fittingLabelWidthWithHeight:40 andFontSize:[UIFont systemFontOfSize:15]];
        
        UIImageView *btn_annonation = [[UIImageView alloc]init];
        [btn_annonation setFrame:CGRectMake(0, 0, width + 35, 50)];
        [btn_annonation setImage:[UIImage imageNamed:@"弹出白框"]];
        
        UILabel *lab_annonation = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, width, 17)];
        [btn_annonation addSubview:lab_annonation];
        [lab_annonation setText:[dic objectForKey:@"name"]];
        [lab_annonation setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
        [lab_annonation setFont:[UIFont systemFontOfSize:15]];
        lab_annonation.textAlignment = NSTextAlignmentCenter;
        lab_annonation.userInteractionEnabled = NO;

        UIImageView *img_jiao = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab_annonation.frame), 19.5, 18, 18)];
        [btn_annonation addSubview:img_jiao];
        [img_jiao setImage:[UIImage imageNamed:@"白框上的小三角"]];
        
        
        BMKActionPaopaoView *custom = [[BMKActionPaopaoView alloc] initWithCustomView:btn_annonation];
        annotationView.paopaoView = custom;
        custom.userInteractionEnabled = YES;
        custom.frame = btn_annonation.frame;
        [annotationView setCalloutOffset:CGPointMake(0, 80)];
        
        UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAnnonationAction:)];
        custom.tag = a;
        [custom addGestureRecognizer:tagGes];
        
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
    return nil;
    
}

#pragma TableViewDelegate -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_tableView.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.arr_tableView objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.arr_tableView.count == 2) {
        if (section == 0) {
            return 0;
        }else{
            return 34;
        }
    }
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lb_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    [lb_title setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    [lb_title setFont:[UIFont systemFontOfSize:14]];
    [lb_title setText:@"   热门医院"];
    [lb_title setTextColor:[UIColor colorWithHexString:@"#A4A4A4"]];
    return lb_title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"mapViewCell";
    MapHospitalTableViewCell *cell = (MapHospitalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MapHospitalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HospitalInMapEntity *entity = [[self.arr_tableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell contentCellWithEntity:entity];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HospitalInMapEntity *entity = [[self.arr_tableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    PuTongPZViewController *vc = [[PuTongPZViewController alloc]init];
    vc.str_hospitalName = entity.name;
    vc.str_hospitalAddress = entity.address;
    vc.str_hospitalId = [NSString stringWithFormat:@"%d",entity.hospitalId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -


-(void)btnAnnonationAction:(UITapGestureRecognizer *)sender{
    NSDictionary *dic = [self.arr_annonation objectAtIndex:sender.view.tag];
    PuTongPZViewController *vc = [[PuTongPZViewController alloc]init];
    vc.str_hospitalName = [dic objectForKey:@"name"];
    vc.str_hospitalAddress = [dic objectForKey:@"address"];
    vc.str_hospitalId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

-(void)puchSearchAction{
    SearchViewController *vc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
