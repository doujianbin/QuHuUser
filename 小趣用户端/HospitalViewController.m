//
//  HospitalViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "HospitalViewController.h"
#import "NSString+Size.h"
#import "PuTongPZViewController.h"
#import "FromHospitalSelectDoctorViewController.h"

@interface HospitalViewController (){
    UIButton *btn_putong;
    UIButton *btn_texu;
}
@property (nonatomic ,retain)UIImageView *img_hospitalPic;

@end

@implementation HospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = [self.dic_hospital objectForKey:@"hospitalName"];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];

    [self createView];
    [self addMidView];
}

- (void)createView{
    self.img_hospitalPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180)];
    [self.view addSubview:self.img_hospitalPic];
    [self.img_hospitalPic sd_setImageWithURL:[self.dic_hospital objectForKey:@"bigImgPath"] placeholderImage:[UIImage imageNamed:@"big"]];

}

-(void)addMidView{
    UIView *sec = [[UIView alloc]initWithFrame:CGRectMake(0, 244, SCREEN_WIDTH, 95)];
    [self.view addSubview:sec];
    [sec setBackgroundColor:[UIColor whiteColor]];
    UIImageView *img_heng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 94.5, SCREEN_WIDTH, 0.5)];
    [sec addSubview:img_heng];
    [img_heng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    btn_putong = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 95)];
    [sec addSubview:btn_putong];
    [btn_putong addTarget:self action:@selector(btn_putongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img_putong = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22, 51, 51)];
    [btn_putong addSubview:img_putong];
    [img_putong setImage:[UIImage imageNamed:@"ic_hushi"]];
    
    UILabel *lab_putong = [[UILabel alloc]initWithFrame:CGRectMake(76, 30, 68, 18)];
    [btn_putong addSubview:lab_putong];
    [lab_putong setText:@"普通陪诊"];
    lab_putong.font = [UIFont systemFontOfSize:17];
    [lab_putong setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UILabel *lab_putong2 = [[UILabel alloc]initWithFrame:CGRectMake(76, 53, 84, 12.5)];
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
    
    UIImageView *img_texu = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22, 51, 51)];
    [btn_texu addSubview:img_texu];
    [img_texu setImage:[UIImage imageNamed:@"ic_texu"]];
    
    UILabel *lab_texu = [[UILabel alloc]initWithFrame:CGRectMake(76, 30, 68, 18)];
    [btn_texu addSubview:lab_texu];
    [lab_texu setText:@"特需陪诊"];
    lab_texu.font = [UIFont systemFontOfSize:17];
    [lab_texu setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UILabel *lab_texu2 = [[UILabel alloc]initWithFrame:CGRectMake(76, 53, 84, 12.5)];
    [btn_texu addSubview:lab_texu2];
    [lab_texu2 setText:@"妥妥专家号预约"];
    lab_texu2.font = [UIFont systemFontOfSize:12];
    [lab_texu2 setTextColor:[UIColor colorWithHexString:@"4A4A4A" alpha:0.5]];
    
    UIView *viewHospital = [[UIView alloc]initWithFrame:CGRectMake(0, 346.5, SCREEN_WIDTH, 40)];
    [self.view addSubview:viewHospital];
    [viewHospital setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12.5, 2, 17)];
    [viewHospital addSubview:img1];
    [img1 setImage:[UIImage imageNamed:@"Rectangle 39"]];
    
    UILabel *lab_allyiyuan = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 52, 14.5)];
    [viewHospital addSubview:lab_allyiyuan];
    [lab_allyiyuan setText:@"医院简介"];
    lab_allyiyuan.font = [UIFont systemFontOfSize:13];
    [lab_allyiyuan setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UIImageView *imgheng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    [viewHospital addSubview:imgheng];
    [imgheng setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    NSString *hospitalIntroduce = [self.dic_hospital objectForKey:@"details"];
    CGFloat strHeight = [hospitalIntroduce fittingLabelHeightWithWidth:SCREEN_WIDTH - 30 andFontSize:[UIFont systemFontOfSize:14]];
    UIView *view_hospitalIntroduce = [[UIView alloc]initWithFrame:CGRectMake(0, 386.5, SCREEN_WIDTH, strHeight + 25)];
    [self.view addSubview:view_hospitalIntroduce];
    [view_hospitalIntroduce setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lab_hospitalIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, strHeight)];
    [view_hospitalIntroduce addSubview:lab_hospitalIntroduce];
    [lab_hospitalIntroduce setText:hospitalIntroduce];
    lab_hospitalIntroduce.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab_hospitalIntroduce.font = [UIFont systemFontOfSize:14];
    lab_hospitalIntroduce.numberOfLines = 0;

    
}

-(void)btn_putongAction{
    PuTongPZViewController *vc = [[PuTongPZViewController alloc]init];
    vc.str_hospitalName = [self.dic_hospital objectForKey:@"hospitalName"];
    vc.str_hospitalAddress = [self.dic_hospital objectForKey:@"address"];
    vc.str_hospitalId = [self.dic_hospital objectForKey:@"hospitalId"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btn_texuAction{
    FromHospitalSelectDoctorViewController *vc = [[FromHospitalSelectDoctorViewController alloc]init];
    vc.hospitalId = [self.dic_hospital objectForKey:@"hospitalId"];
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
