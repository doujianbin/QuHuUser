//
//  SignInViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (nonatomic ,retain)UITextField *tef_phoneNum;
@property (nonatomic ,retain)UITextField *tef_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_denglu;
@property (nonatomic        )int timeRemaining;//剩余时间

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [self creatView];
}

-(void)creatView{
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(15, 15 + 64, SCREEN_WIDTH - 30, 44)];
    [self.view addSubview:aView];
    [aView setBackgroundColor:[UIColor whiteColor]];
    aView.layer.cornerRadius = 3.0f;
    aView.layer.masksToBounds = YES;
    aView.layer.borderWidth = 0.5f;
    aView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDCDD"] CGColor];
    
    self.tef_phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, 200, 44)];
    [aView addSubview:self.tef_phoneNum];
    [self.tef_phoneNum setBackgroundColor:[UIColor whiteColor]];
    self.tef_phoneNum.keyboardType = UIKeyboardTypePhonePad;
    self.tef_phoneNum.font = [UIFont systemFontOfSize:17];
    self.tef_phoneNum.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.tef_phoneNum setPlaceholder:@"手机号"];
    
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(15, 69 + 64, 230, 44)];
    [self.view addSubview:bView];
    [bView setBackgroundColor:[UIColor whiteColor]];
    bView.layer.cornerRadius = 3.0f;
    bView.layer.masksToBounds = YES;
    bView.layer.borderWidth = 0.5f;
    bView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDCDD"] CGColor];
    
    self.tef_yanzhengma = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, 150, 44)];
    [bView addSubview:self.tef_yanzhengma];
    [self.tef_yanzhengma setBackgroundColor:[UIColor whiteColor]];
    self.tef_yanzhengma.keyboardType = UIKeyboardTypePhonePad;
    self.tef_yanzhengma.font = [UIFont systemFontOfSize:17];
    self.tef_yanzhengma.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.tef_yanzhengma setPlaceholder:@"验证码"];
    
    self.btn_yanzhengma = [[UIButton alloc]initWithFrame:CGRectMake(250, 69 + 64, SCREEN_WIDTH - 250 - 15, 44)];
    [self.view addSubview:self.btn_yanzhengma];
    [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    self.btn_yanzhengma.layer.cornerRadius = 3.0f;
    self.btn_yanzhengma.layer.masksToBounds = YES;
    [self.btn_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.btn_yanzhengma.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btn_yanzhengma addTarget:self action:@selector(yanzhengmaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_denglu = [[UIButton alloc]initWithFrame:CGRectMake(15, 128 + 64, SCREEN_WIDTH - 30, 44)];
    [self.view addSubview:self.btn_denglu];
    self.btn_denglu.layer.cornerRadius = 3.0f;
    self.btn_denglu.layer.masksToBounds = YES;
    [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [self.btn_denglu setTitle:@"登录" forState:UIControlStateNormal];
    [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.btn_denglu.titleLabel.font = [UIFont systemFontOfSize:18];
    
}

-(void)yanzhengmaAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    self.timeRemaining = MAX_TIMEREMAINING;
    [button setTitle:[NSString stringWithFormat:@"%d秒",MAX_TIMEREMAINING] forState:UIControlStateDisabled];
    [self startCountDownForReauth];
}

- (void)startCountDownForReauth
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(countingDownForReauthAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [timer fire];
}

//定时改变按钮名称方法（注：该方法每隔间隔时间都会调用一次）
- (void)countingDownForReauthAction:(NSTimer *)timer
{
    if (self.timeRemaining > 0) {
        NSString *string = [NSString stringWithFormat:@"%dS后重新获取",self.timeRemaining--];
        [self.btn_yanzhengma setTitle:string forState:UIControlStateDisabled];
        [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
        [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#969696"] forState:UIControlStateNormal];
        
    }else{
        [timer invalidate];
        [self performSelectorOnMainThread:@selector(updateButtonStateAction:)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

//更新验证码按钮状态
-(void)updateButtonStateAction:(id)sender
{
    //先改变状态，再设置该状态下的文字显示
    self.btn_yanzhengma.enabled = YES;
    [self.btn_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
}

-(void)viewAction{
    [self.tef_phoneNum resignFirstResponder];
    [self.tef_yanzhengma resignFirstResponder];
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
