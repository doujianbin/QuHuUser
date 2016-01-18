//
//  SignInViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SignInViewController.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface SignInViewController ()<UITextFieldDelegate>

@property (nonatomic ,retain)UITextField *tef_phoneNum;
@property (nonatomic ,retain)UITextField *tef_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_denglu;
@property (nonatomic        )int timeRemaining;//剩余时间

@property (nonatomic ,strong)AFNManager *manager;

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
    self.tef_phoneNum.delegate = self;
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
    self.tef_yanzhengma.delegate = self;
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
    [self.btn_denglu addTarget:self action:@selector(btnDengLuAction) forControlEvents:UIControlEventTouchUpInside];


    
}

-(void)yanzhengmaAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,MessageCode];
    self.manager = [[AFNManager alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.tef_phoneNum.text, @"phoneNumber", nil];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"%@",responseDic);
        if ([[responseDic objectForKey:@"status"] isEqualToString:SUCCESS]) {
            NSLog(@"发送成功");
        }
        
    } fail:^(NSError *error) {
        
    }];
    
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

-(void)btnDengLuAction{
    self.manager = [[AFNManager alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,RegisterOrRefresh];
    NSString *strUserName = [NSString stringWithFormat:@"U_%@",self.tef_phoneNum.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strUserName, @"username",self.tef_yanzhengma.text,@"password", nil];
    
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"验证是否正确=%@",responseDic);
        
        if ([[responseDic objectForKey:@"status"] isEqualToString:SUCCESS]) {
            [self GetLoginToken];
            
        }
//        if ([[responseDic objectForKey:@"status"] isEqualToString:ERROR]) {
//            NSLog(@"错误信息:%@",[responseDic objectForKey:@"message"]);
//        }
    } fail:^(NSError *error) {
        
    }];
    
    
}

-(void)GetLoginToken{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",  @"text/json", @"text/html", @"text/javascript",@"x-www-form-urlencoded",nil]];
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"POST"];
    NSString *strHttpHeader = [NSString stringWithFormat:@"Basic %@",[CommonFunc base64StringFromText:@"accompany-user-client:ccbPASSquyiyuan20154421"]];
    [request setValue:strHttpHeader
   forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *strUserName = [NSString stringWithFormat:@"U_%@",self.tef_phoneNum.text];
    NSString *token = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",strUserName,self.tef_yanzhengma.text];
    NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         // 成功后的处理
                                         NSLog(@"登陆成功返回 == %@",responseObject);
                                         NSString *token_type = [responseObject objectForKey:@"token_type"];
                                         NSString *access_token = [responseObject objectForKey:@"access_token"];
                                         NSString *httpHeader = [NSString stringWithFormat:@"%@ %@",token_type,access_token];
                                         [LoginStorage savePhoneNum:self.tef_phoneNum.text];
                                         [LoginStorage saveYanZhengMa:self.tef_yanzhengma.text];
                                         [LoginStorage saveHTTPHeader:httpHeader];
                                         [LoginStorage saveIsLogin:YES];
                                         if (self.isSetRootView) {
                                             [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         // 失败后的处理
                                         NSLog(@"%@", error);
                                     }];
    [manager.operationQueue addOperation:operation];

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
