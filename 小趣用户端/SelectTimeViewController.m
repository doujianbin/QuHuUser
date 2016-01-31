//
//  SelectTimeViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SelectTimeViewController.h"
#import "TXOrderViewController.h"
#import "DoctorDetailTableViewCell.h"
#import "DayGroupEntity.h"
#import "HospitalGroupEntity.h"
#import "AppointEntity.h"
#import "DayButton.h"
#import "HospitalTimeTableViewCell.h"

@interface SelectTimeViewController ()<UITableViewDataSource,UITableViewDelegate,HospitalTimeTableViewCellDelegate>

@property (nonatomic,retain)AFNManager *manager;
@property (nonatomic,strong)UITableView *tb_hospital;
@property (nonatomic,strong)UIScrollView *scl_back;
@property (nonatomic,strong)NSString     *str_yearMonth;
@property (nonatomic,strong)NSArray      *arr_dayGroup;
@property (nonatomic,strong)NSMutableArray *arr_button;
@property (nonatomic,strong)NSArray        *arr_hospitalGroup;
@property (nonatomic,strong)UIView         *v_tableViewBack;
@property (nonatomic,strong)DayGroupEntity *dayEntity;

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_dayGroup = [NSArray array];
    self.arr_button = [NSMutableArray array];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = self.doctorEntity.name;
    [self.view addSubview:[UIView new]];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
    [self getDoctorTimeMsg];
}

- (void)onCreate{
    self.scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.scl_back];
    
    DoctorDetailTableViewCell *doctorDetailView = [[DoctorDetailTableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [doctorDetailView setBackgroundColor:[UIColor whiteColor]];
    [doctorDetailView contentDoctorDetailWithDoctorEntity:self.doctorEntity];
    [self.scl_back addSubview:doctorDetailView];
    
    UIView *v_dayGroup = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(doctorDetailView.frame) + 8, SCREEN_WIDTH, 129)];
    [v_dayGroup setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [self.scl_back addSubview:v_dayGroup];
    
    UILabel *lb_yearMonth = [[UILabel alloc]initWithFrame:CGRectMake(14.5, 10, 150, 18)];
    [lb_yearMonth setFont:[UIFont systemFontOfSize:17]];
    [lb_yearMonth setTextColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [lb_yearMonth setText:self.str_yearMonth];
    [v_dayGroup addSubview:lb_yearMonth];
    
    CGFloat  width_left = 8;
    CGFloat  width_label = 32;
    CGFloat  width_center = (SCREEN_WIDTH - 8*2 - self.arr_dayGroup.count * width_label)/(self.arr_dayGroup.count - 1);
    
    for (int i = 0; i < self.arr_dayGroup.count; i ++) {
        DayGroupEntity *dayGroupEntity = [self.arr_dayGroup objectAtIndex:i];
        UILabel  *lb_titleWeek = [[UILabel alloc]initWithFrame:CGRectMake(width_left + i*width_label + i*width_center, CGRectGetMaxY(lb_yearMonth.frame) + 10, width_label, width_label)];
        [lb_titleWeek setTextColor:[UIColor colorWithHexString:@"#FFFFFFFF"]];
        [lb_titleWeek setFont:[UIFont systemFontOfSize:17]];
        [lb_titleWeek setTextAlignment:NSTextAlignmentCenter];
        [lb_titleWeek setText:dayGroupEntity.week];
        [v_dayGroup addSubview:lb_titleWeek];
        
        DayButton *dayButton = [[DayButton alloc]initWithFrame:CGRectMake(width_left + i*width_label + i*width_center, CGRectGetMaxY(lb_titleWeek.frame) + 10, width_label, width_label)];
        dayButton.lb_day.text = dayGroupEntity.day;
        dayButton.tag = i;
        [dayButton addTarget:self action:@selector(selectDayAction:) forControlEvents:UIControlEventTouchUpInside];
        if (dayGroupEntity.hospitalGroup.count > 0) {
            [dayButton.iv_status setHidden:NO];
        }else{
            [dayButton.iv_status setHidden:YES];
        }
        if (i == 0) {
            [dayButton setBackgroundImage:[UIImage imageNamed:@"active"] forState:UIControlStateNormal];
        }
        [v_dayGroup addSubview:dayButton];
        [self.arr_button addObject:dayButton];
    }
    
    self.v_tableViewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.scl_back.frame.size.height - (70 + 10 + 129))];
    UIImage *im_memo = [UIImage imageNamed:@"Group"];
    UIImageView *iv_memo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/ 2 - im_memo.size.width / 2,(self.scl_back.frame.size.height - (70 + 10 + 129))/2 - im_memo.size.height/2 - 30 ,im_memo.size.width,im_memo.size.height)];
    [iv_memo setImage:im_memo];
    [self.v_tableViewBack addSubview:iv_memo];
    UILabel *lb_memo = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv_memo.frame) + 30, SCREEN_WIDTH, 21)];
    [lb_memo setFont:[UIFont systemFontOfSize:14]];
    [lb_memo setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    [lb_memo setTextAlignment:NSTextAlignmentCenter];
    [lb_memo setText:@"今日休息，看看其他时间吧~"];
    [self.v_tableViewBack addSubview:lb_memo];
    
    CGFloat height_tableView = 0;
    for (HospitalGroupEntity *entity in self.arr_hospitalGroup) {
        height_tableView = height_tableView + [self getCellHeightWithHospitalGroupEntity:entity];
    }
    self.tb_hospital = [[UITableView alloc]init];
    [self.tb_hospital setScrollEnabled:NO];
    [self.tb_hospital setDelegate:self];
    [self.tb_hospital setDataSource:self];
    [self.tb_hospital setSeparatorColor:[UIColor clearColor]];
    [self.scl_back addSubview:self.tb_hospital];
    [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tb_hospital.frame) + 10)];
    if (self.arr_hospitalGroup.count > 0) {
        [self.tb_hospital setFrame:CGRectMake(0,70 + 10 + 129, SCREEN_WIDTH, height_tableView + (self.arr_hospitalGroup.count - 1)*10)];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tb_hospital.frame) + 10)];
        [self.tb_hospital setBackgroundView:nil];
    }else{
        [self.tb_hospital setFrame:CGRectMake(0,70 + 10 + 129, SCREEN_WIDTH,self.scl_back.frame.size.height - (70 + 10 + 129))];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tb_hospital.frame))];
        [self.tb_hospital setBackgroundView:self.v_tableViewBack];
    }
    
}

-(void)getDoctorTimeMsg{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,UserSelectDoctorMsg];
    NSDictionary *dic = @{@"doctorId":self.doctorEntity._id};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"加号明细:%@",responseDic);
        NSMutableDictionary *dicAll = [responseDic objectForKey:@"data"];
        self.str_yearMonth = [dicAll objectForKey:@"yearMonth"];
        self.arr_dayGroup = [DayGroupEntity parseDayGroupListWithJson:[dicAll objectForKey:@"dayGroup"]];
        self.dayEntity = [self.arr_dayGroup firstObject];
        self.arr_hospitalGroup = self.dayEntity.hospitalGroup;
        [self onCreate];
    } fail:^(NSError *error) {
        
    }];
}

- (void)selectDayAction:(UIButton *)btn_sender{
    for (UIButton *btn in self.arr_button) {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    [btn_sender setBackgroundImage:[UIImage imageNamed:@"active"] forState:UIControlStateNormal];
    self.dayEntity = [self.arr_dayGroup objectAtIndex:btn_sender.tag];
    self.arr_hospitalGroup = self.dayEntity.hospitalGroup;
    [self.tb_hospital reloadData];
    CGFloat height_tableView = 0;
    for (HospitalGroupEntity *entity in self.arr_hospitalGroup) {
        height_tableView = height_tableView + [self getCellHeightWithHospitalGroupEntity:entity];
    }
    if (self.arr_hospitalGroup.count > 0) {
        [self.tb_hospital setFrame:CGRectMake(0,70 + 10 + 129, SCREEN_WIDTH, height_tableView + (self.arr_hospitalGroup.count - 1)*10)];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tb_hospital.frame) + 10)];
        [self.tb_hospital setBackgroundView:nil];
    }else{
        [self.tb_hospital setFrame:CGRectMake(0,70 + 10 + 129, SCREEN_WIDTH,self.scl_back.frame.size.height - (70 + 10 + 129))];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.tb_hospital.frame))];
        [self.tb_hospital setBackgroundView:self.v_tableViewBack];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1.0;
    }else{
        return 9.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_hospitalGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalGroupEntity *entity = [self.arr_hospitalGroup objectAtIndex:indexPath.row];
    return [self getCellHeightWithHospitalGroupEntity:entity];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalTimeTableViewCell *cell = [[HospitalTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HospitalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    HospitalGroupEntity *entity = [self.arr_hospitalGroup objectAtIndex:indexPath.section];
    [cell contentCellWithHospitalGroupEntity:entity withIndex:(int)indexPath.section + 1];
    return cell;
}

- (CGFloat)getCellHeightWithHospitalGroupEntity:(HospitalGroupEntity *)entity{
    CGFloat height = 0;
    if (entity.appointList.count % 4 > 0) {
        height = 70 + 14.5*2 + (entity.appointList.count / 4 + 1)*27.5 + entity.appointList.count / 4 * 12.5;
    }else{
        height = 70 + 14.5*2 + entity.appointList.count / 4*27.5 + (entity.appointList.count / 4 - 1) * 12.5;
    }
    return height;
}

- (void)didSelectedWithAppointEntity:(AppointEntity *)appointEntity withHospitalGroupEntity:(HospitalGroupEntity *)hospitalGroupEntity{
    
    TXOrderViewController *txorderView = [[TXOrderViewController alloc]init];
    txorderView.doctorEntity = self.doctorEntity;
    txorderView.appointEntity = appointEntity;
    txorderView.hospitalEntity = hospitalGroupEntity;
    txorderView.dayEntity = self.dayEntity;
    txorderView.str_yearMonth = self.str_yearMonth;
    [self.navigationController pushViewController:txorderView animated:YES];
}



- (void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
