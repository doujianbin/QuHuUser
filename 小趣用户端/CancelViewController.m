//
//  CancelViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/23.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CancelViewController.h"
#import "GCPlaceholderTextView.h"
#import "UITextView+ResignKeyboard.h"
#import "Toast+UIView.h"

@interface CancelViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UIView *v_backView;
@property (nonatomic ,strong)UIButton *btn_1;
@property (nonatomic ,strong)UIButton *btn_2;
@property (nonatomic ,strong)UIButton *btn_3;
@property (nonatomic ,strong)UIButton *img_1;
@property (nonatomic ,strong)UIButton *img_2;
@property (nonatomic ,strong)UIButton *img_3;
@property (nonatomic ,strong)GCPlaceholderTextView *cancelView;
@property (nonatomic ,strong)NSString *str_reason;

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"取消原因";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 21.5, 67, 17)];
    [btnR setTitle:@"客服咨询" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    [btnR sizeToFit];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnRight;
    [btnR addTarget:self action:@selector(NavRightAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    [self onCreate];
}

-(void)onCreate{
    self.v_backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [self.view addSubview:self.v_backView];
    [self.v_backView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labRea = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH - 30, 17)];
    [self.v_backView addSubview:labRea];
    [labRea setText:@"请选择一下取消原因"];
    [labRea setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [labRea setFont:[UIFont systemFontOfSize:17]];
    
    UIImageView *imgline1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 37.5, SCREEN_WIDTH, 0.5)];
    [self.v_backView addSubview:imgline1];
    [imgline1 setImage:[UIImage imageNamed:@"02-04取消原因@2x_02"]];
    
    self.img_1 = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline1.frame) + 17, 10, 10)];
    [self.v_backView addSubview:self.img_1];
    [self.img_1 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_1.frame) + 10, CGRectGetMaxY(imgline1.frame) + 10, SCREEN_WIDTH - (CGRectGetMaxX(self.img_1.frame) + 10) - 10, 24)];
    [self.v_backView addSubview:self.btn_1];
    [self.btn_1 setTitle:@"等待时间太长，没人接单" forState:UIControlStateNormal];
    [self.btn_1 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    self.btn_1.titleLabel.font = [UIFont systemFontOfSize:17];
    self.btn_1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btn_1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imgline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgline1.frame) + 44, SCREEN_WIDTH, 0.5)];
    [self.v_backView addSubview:imgline2];
    [imgline2 setImage:[UIImage imageNamed:@"02-04取消原因@2x_02"]];
    
    self.img_2 = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline2.frame) + 17, 10, 10)];
    [self.v_backView addSubview:self.img_2];
    [self.img_2 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_1.frame) + 10, CGRectGetMaxY(imgline2.frame) + 10, SCREEN_WIDTH - (CGRectGetMaxX(self.img_2.frame) + 10) - 10, 24)];
    [self.v_backView addSubview:self.btn_2];
    [self.btn_2 setTitle:@"信息填写错误，重新下单" forState:UIControlStateNormal];
    [self.btn_2 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    self.btn_2.titleLabel.font = [UIFont systemFontOfSize:17];
    self.btn_2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btn_2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgline3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgline2.frame) + 44, SCREEN_WIDTH, 0.5)];
    [self.v_backView addSubview:imgline3];
    [imgline3 setImage:[UIImage imageNamed:@"02-04取消原因@2x_02"]];
    
    self.img_3 = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline3.frame) + 17, 10, 10)];
    [self.v_backView addSubview:self.img_3];
    [self.img_3 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_3 addTarget:self action:@selector(btn3Action) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_3 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_2.frame) + 10, CGRectGetMaxY(imgline3.frame) + 10, SCREEN_WIDTH - (CGRectGetMaxX(self.img_2.frame) + 10) - 10, 24)];
    [self.v_backView addSubview:self.btn_3];
    [self.btn_3 setTitle:@"我不想用了" forState:UIControlStateNormal];
    [self.btn_3 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    self.btn_3.titleLabel.font = [UIFont systemFontOfSize:17];
    self.btn_3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btn_3 addTarget:self action:@selector(btn3Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgline4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgline3.frame) + 44, SCREEN_WIDTH, 0.5)];
    [self.v_backView addSubview:imgline4];
    [imgline4 setImage:[UIImage imageNamed:@"02-04取消原因@2x_02"]];
    
    UIView *v_cancelBack = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline4.frame) + 15, SCREEN_WIDTH - 30, 95)];
    [self.v_backView addSubview:v_cancelBack];
    v_cancelBack.layer.borderColor = [[UIColor colorWithHexString:@"#e8e8e8"] CGColor];
    v_cancelBack.layer.borderWidth = 0.5;
    
    self.cancelView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 5, v_cancelBack.frame.size.width - 10, v_cancelBack.frame.size.height - 10)];
    [v_cancelBack addSubview:self.cancelView];
    [self.cancelView setPlaceholder:@"其他原因："];
    self.cancelView.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    self.cancelView.font = [UIFont systemFontOfSize:17];
    [self.cancelView setNormalInputAccessory];
    self.cancelView.delegate = self;
    
    UIButton *btn_cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH, 44)];
    [self.view addSubview:btn_cancel];
    [btn_cancel setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
    [btn_cancel setTitle:@"确认" forState:UIControlStateNormal];
    btn_cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn_cancel addTarget:self action:@selector(tijiaoReason) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btn1Action{
    [self.cancelView setText:@""];
    [self.cancelView resignFirstResponder];
    self.str_reason = @"等待时间太长，没人接单";
    [self.img_1 setBackgroundImage:[UIImage imageNamed:@"cancelSelect"] forState:UIControlStateNormal];
    [self.img_2 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_3 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    
    [self.btn_1 setTitleColor:[UIColor colorWithHexString:@"#fa6262"] forState:UIControlStateNormal];
    [self.btn_2 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    [self.btn_3 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
}

-(void)btn2Action{
    [self.cancelView setText:@""];
    [self.cancelView resignFirstResponder];
    self.str_reason = @"信息填写错误，重新下单";
    [self.img_2 setBackgroundImage:[UIImage imageNamed:@"cancelSelect"] forState:UIControlStateNormal];
    [self.img_1 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_3 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.btn_2 setTitleColor:[UIColor colorWithHexString:@"#fa6262"] forState:UIControlStateNormal];
    [self.btn_1 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    [self.btn_3 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
}

-(void)btn3Action{
    [self.cancelView setText:@""];
    [self.cancelView resignFirstResponder];
    self.str_reason = @"我不想用了";
    [self.img_3 setBackgroundImage:[UIImage imageNamed:@"cancelSelect"] forState:UIControlStateNormal];
    [self.img_1 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_2 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.btn_3 setTitleColor:[UIColor colorWithHexString:@"#fa6262"] forState:UIControlStateNormal];
    [self.btn_1 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    [self.btn_2 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.cancelView.text = @"";
    [self.img_3 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_1 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.img_2 setBackgroundImage:[UIImage imageNamed:@"cancelDiselect"] forState:UIControlStateNormal];
    [self.btn_3 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    [self.btn_1 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    [self.btn_2 setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.str_reason = self.cancelView.text;
}

-(void)tijiaoReason{
    NSLog(@"%@",self.str_reason);
    if (self.str_reason.length > 0) {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,UpdateCancelreason];
        NSDictionary *dic = @{@"orderId":self.str_OrderId,@"cancelReason":self.str_reason};
        
        AFNManager *manager = [[AFNManager alloc]init];
        [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
            if ([Status isEqualToString:SUCCESS]) {
                [self.view makeToast:@"提交成功" duration:1.0 position:@"center"];
                [NSTimer scheduledTimerWithTimeInterval:1.1
                                                 target:self
                                               selector:@selector(NavLeftAction)
                                               userInfo:nil
                                                repeats:NO];
            }else{
                FailMessage;
            }
        } fail:^(NSError *error) {
            NetError;
        }];
    }else{
        [self.view makeToast:@"请选择取消原因" duration:1.0 position:@"center"];
    }
    
}

-(void)NavLeftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)NavRightAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:[LoginStorage phonenum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
    alert.tag = 11;
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            NSString *str1 = @"tel://";
            NSString *str2 = [LoginStorage phonenum];
            NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
        }
    }
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
