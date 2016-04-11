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
#import "BPush.h"
#import "Toast+UIView.h"
#import "WebViewViewController.h"
#import "TalkingData.h"

@interface SignInViewController ()<UITextFieldDelegate>

@property (nonatomic ,retain)UITextField *tef_phoneNum;
@property (nonatomic ,retain)UITextField *tef_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_yanzhengma;
@property (nonatomic ,retain)UIButton *btn_denglu;
@property (nonatomic        )int timeRemaining;//剩余时间
@property (nonatomic ,strong)UIView *v_pregnancyStatus;

@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSString *pregnancyStatus;
@property (nonatomic ,assign)int YZMStatus;   // 1为倒计时中  2为不在倒计时中

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    self.title = @"验证手机";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction)];
    
    
    [self.view addGestureRecognizer:tapGesture];
    if (self.notBack) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.YZMStatus = 2;
    [self creatView];

}

-(void)creatView{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
    [self.view addSubview:lab];
    [lab setText:@"为方便护士联系您，请验证手机"];
    [lab setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab setFont:[UIFont systemFontOfSize:15]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 145, 44)];
    [self.view addSubview:aView];
    [aView setBackgroundColor:[UIColor whiteColor]];
    aView.layer.cornerRadius = 3.0f;
    aView.layer.masksToBounds = YES;
    aView.layer.borderWidth = 0.5f;
    aView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDCDD"] CGColor];
    
    self.tef_phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(12, 0,SCREEN_WIDTH - 142 , 44)];
    [aView addSubview:self.tef_phoneNum];
    [self.tef_phoneNum setBackgroundColor:[UIColor whiteColor]];
    self.tef_phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    self.tef_phoneNum.font = [UIFont systemFontOfSize:15];
    self.tef_phoneNum.delegate = self;
    self.tef_phoneNum.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.tef_phoneNum setPlaceholder:@"请输入手机号"];
    
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(15, 69 + 35, SCREEN_WIDTH - 30, 44)];
    [self.view addSubview:bView];
    [bView setBackgroundColor:[UIColor whiteColor]];
    bView.layer.cornerRadius = 3.0f;
    bView.layer.masksToBounds = YES;
    bView.layer.borderWidth = 0.5f;
    bView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDCDD"] CGColor];
    
    self.tef_yanzhengma = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 30 - 12, 44)];
    [bView addSubview:self.tef_yanzhengma];
    [self.tef_yanzhengma setBackgroundColor:[UIColor whiteColor]];
    self.tef_yanzhengma.keyboardType = UIKeyboardTypeNumberPad;
    self.tef_yanzhengma.font = [UIFont systemFontOfSize:15];
    self.tef_yanzhengma.delegate = self;
    self.tef_yanzhengma.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.tef_yanzhengma setPlaceholder:@"请输入验证码"];
    
    self.btn_yanzhengma = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tef_phoneNum.frame) + 10, 50, 105, 44)];
    [self.view addSubview:self.btn_yanzhengma];
    [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
    self.btn_yanzhengma.layer.cornerRadius = 3.0f;
    self.btn_yanzhengma.layer.masksToBounds = YES;
    [self.btn_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    self.btn_yanzhengma.enabled = NO;
    self.btn_yanzhengma.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btn_yanzhengma addTarget:self action:@selector(yanzhengmaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_denglu = [[UIButton alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(bView.frame) + 10, SCREEN_WIDTH - 30, 44)];
    [self.view addSubview:self.btn_denglu];
    self.btn_denglu.layer.cornerRadius = 3.0f;
    self.btn_denglu.layer.masksToBounds = YES;
    [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
    [self.btn_denglu setTitle:@"确认" forState:UIControlStateNormal];
    [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    self.btn_denglu.enabled = NO;
    self.btn_denglu.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.btn_denglu addTarget:self action:@selector(btnDengLuAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:@"点击确认，即表示您同意《趣护用户服务协议》"];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#969696"] range:NSMakeRange(0, 11)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 11)];
    
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a90e2"] range:NSMakeRange(11, 10)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(11, 10)];
    
    UIButton *btn_xieyi = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btn_denglu.frame) + 10, 280, 14)];
    [self.view addSubview:btn_xieyi];
    [btn_xieyi setAttributedTitle:myStr forState:UIControlStateNormal];
    [btn_xieyi addTarget:self action:@selector(xieyiAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)xieyiAction{
    WebViewViewController *webVc = [[WebViewViewController alloc]init];
    webVc.strTitle = @"趣护用户服务协议";
    webVc.strUrl = @"http://wx.haohushi.me/web/#/commonpage/agreement/ios/2";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

-(void)yanzhengmaAction:(id)sender{
    self.YZMStatus = 1;
    self.btn_yanzhengma.enabled = NO;
    [self.tef_phoneNum resignFirstResponder];
    //    BOOL phoneN = [self isMobileNumber:self.tef_phoneNum.text];
    UIButton *button = (UIButton *)sender;
    if (self.tef_phoneNum.text.length > 3) {
        
        NSString *firstStr = [self.tef_phoneNum.text substringToIndex:1];
        NSString *secStr = [self.tef_phoneNum.text substringWithRange:NSMakeRange(1, 1)];
        
        if (self.tef_phoneNum.text.length == 0) {
            [self.view makeToast:@"请输入手机号" duration:1.0 position:@"center"];
        }else if (self.tef_phoneNum.text.length != 11){
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
        }else if (![firstStr isEqualToString:@"1"]){
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
        }else if ([secStr isEqualToString:@"0"] || [secStr isEqualToString:@"1"] || [secStr isEqualToString:@"2"] || [secStr isEqualToString:@"6"]  || [secStr isEqualToString:@"9"]){
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
        }
        else{
            
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,MessageCode];
            self.manager = [[AFNManager alloc]init];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.tef_phoneNum.text, @"phoneNumber", nil];
            [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
                NSLog(@"%@",responseDic);
                self.btn_yanzhengma.enabled = YES;
                if ([[responseDic objectForKey:@"status"] isEqualToString:SUCCESS]) {
                    [self.view makeToast:@"验证码已发送" duration:1.0 position:@"center"];
                    button.enabled = NO;
                    self.timeRemaining = MAX_TIMEREMAINING;
                    [button setTitle:[NSString stringWithFormat:@"%d秒",MAX_TIMEREMAINING] forState:UIControlStateDisabled];
                    [self startCountDownForReauth];
                }else{
                    FailMessage;
                }
                
            } fail:^(NSError *error) {
                NetError;
                self.btn_yanzhengma.enabled = YES;
            }];
            
        }
    }else{
        [self.view makeToast:@"请输入手机号" duration:1.0 position:@"center"];
    }
    
}

- (void)startCountDownForReauth
{
//    [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
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
        NSString *string = [NSString stringWithFormat:@"%d秒",self.timeRemaining--];
        [self.btn_yanzhengma setTitle:string forState:UIControlStateDisabled];
        [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
        [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
        
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
    self.YZMStatus = 2;
    self.btn_yanzhengma.enabled = YES;
    [self.btn_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
}

-(void)btnDengLuAction{
    NSLog(@"----------------------");
    self.btn_denglu.enabled = NO;
    if (self.tef_phoneNum.text.length > 3) {
        
        NSString *firstStr = [self.tef_phoneNum.text substringToIndex:1];
        NSString *secStr = [self.tef_phoneNum.text substringWithRange:NSMakeRange(1, 1)];
        if (self.tef_phoneNum.text.length == 0) {
            [self.view makeToast:@"请输入手机号" duration:1.0 position:@"center"];
            return;
        }
        if (self.tef_yanzhengma.text.length == 0) {
            [self.view makeToast:@"请输入验证码" duration:1.0 position:@"center"];
            return;
        }
        if (self.tef_phoneNum.text.length != 11) {
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
            return;
        }
        if (![firstStr isEqualToString:@"1"]){
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
            return;
        }if ([secStr isEqualToString:@"0"] || [secStr isEqualToString:@"1"] || [secStr isEqualToString:@"2"] || [secStr isEqualToString:@"6"]  || [secStr isEqualToString:@"9"]){
            [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
            return;
        }
        else{
            
            self.manager = [[AFNManager alloc]init];
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,RegisterOrRefresh];
            NSString *strUserName = [NSString stringWithFormat:@"U_%@",self.tef_phoneNum.text];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strUserName, @"username",self.tef_yanzhengma.text,@"password", nil];
            
            [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
                NSLog(@"验证是否正确=%@",responseDic);
                //                [self createPregnancyView];
                if ([Status isEqualToString:SUCCESS]) {
                    if (![[[responseDic objectForKey:@"data"] objectForKey:@"nickName"] isKindOfClass:[NSNull class]]) {
                        
                        [LoginStorage savenickName:[[responseDic objectForKey:@"data"] objectForKey:@"nickName"]];
                    }
                    if (![[[responseDic objectForKey:@"data"] objectForKey:@"photo"] isKindOfClass:[NSNull class]]) {
                        
                        [LoginStorage savephoto:[[responseDic objectForKey:@"data"] objectForKey:@"photo"]];
                    }
                    if (![[[responseDic objectForKey:@"data"] objectForKey:@"pregnancyStatus"] isKindOfClass:[NSNull class]]) {
                        
                        [LoginStorage savePregnancyStatus:[[responseDic objectForKey:@"data"] objectForKey:@"pregnancyStatus"]];
                    }
                    [self GetLoginToken];
                    
                }else{
                    [self.view makeToast:Message duration:1.0 position:@"center"];
                }
                
            } fail:^(NSError *error) {
                [self.view makeToast:@"网络不给力，请稍后再试" duration:1.0 position:@"center"];
            }];
        }
    }else{
        [self.view makeToast:@"请输入手机号" duration:1.0 position:@"center"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //得到输入框的内容
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.tef_phoneNum == textField) {
        if ([toBeString length] == 11) {
            if (self.YZMStatus == 2) {
                self.btn_yanzhengma.enabled = YES;
                [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#fffff"] forState:UIControlStateNormal];
                [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
                if ([self.tef_yanzhengma.text length] == 6) {
                    self.btn_denglu.enabled = YES;
                    [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
                }
            }
        }else if ([toBeString length] < 11){
            if (self.YZMStatus == 2) {
                
                self.btn_yanzhengma.enabled = NO;
//                self.btn_denglu.enabled = NO;
                [self.btn_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
                [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
//                [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
//                [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
            }else{
                self.btn_yanzhengma.enabled = NO;
//                self.btn_denglu.enabled = NO;
                [self.btn_yanzhengma setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
                [self.btn_yanzhengma setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
//                [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
//                [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
            }
        }else if ([toBeString length] > 11){
            return NO;
        }
    }else if (self.tef_yanzhengma == textField){
        if ([toBeString length] == 6) {
            if ([self.tef_phoneNum.text length] == 11) {
                self.btn_denglu.enabled = YES;
                [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
                [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            }
        } else if ([toBeString length] < 6) {
            self.btn_denglu.enabled = NO;
            [self.btn_denglu setBackgroundColor:[UIColor colorWithHexString:@"#dedede"]];
            [self.btn_denglu setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
        }else if ([toBeString length] > 6) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
                                         [TalkingData trackEvent:@"用户登录/注册成功"];
                                         [LoginStorage savePhoneNum:self.tef_phoneNum.text];
                                         [LoginStorage saveYanZhengMa:self.tef_yanzhengma.text];
                                         [LoginStorage saveHTTPHeader:httpHeader];
                                         [LoginStorage saveIsLogin:YES];
                                         [self saveChannelId];
                                         NSString *pregnancyStatus = [NSString stringWithFormat:@"%@",[LoginStorage PregnancyStatus]];
                                         if ([pregnancyStatus isEqualToString:@"0"]) {
                                                                                          // 未填写过孕期
                                             [self createPregnancyView];
                                             [self.tef_phoneNum resignFirstResponder];
                                             [self.tef_yanzhengma resignFirstResponder];
                                         }else{
                                             if (self.isSetRootView) {
                                                 [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
                                             }else{
                                                 if (self.notBack) {
                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                 }else{
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 }
                                             }
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         // 失败后的处理
                                         NSLog(@"%@", error);
                                         self.btn_denglu.enabled = YES;
                                     }];
    [manager.operationQueue addOperation:operation];
    
}

-(void)saveChannelId{
    NSString *channelId = [BPush getChannelId];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,SaveChannelId];
    NSDictionary *dic = @{@"channelId":channelId,@"deviceType":@"1"};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)createPregnancyView{
    self.v_pregnancyStatus = [[UIView alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.v_pregnancyStatus.clipsToBounds = YES;
    [self.v_pregnancyStatus setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.22, SCREEN_WIDTH, 17)];
    [self.v_pregnancyStatus addSubview:lab1];
    [lab1 setText:@"趣姐产检陪护。关心爱，用心爱，值得爱"];
    [lab1 setFont:[UIFont systemFontOfSize:17]];
    [lab1 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    lab1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame) + 15, SCREEN_WIDTH, 20)];
    [self.v_pregnancyStatus addSubview:lab2];
    lab2.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc]initWithString:@"您或您的家人是否已是准妈妈？"];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0,10)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, 10)];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(10, 4)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(10, 4)];
    [lab2 setAttributedText:myStr];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, CGRectGetMaxY(lab2.frame) + 60, 120, 120)];
    [self.v_pregnancyStatus addSubview:btn1];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"是否在孕期弹层@2x_03"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, CGRectGetMaxY(btn1.frame) + 50, 120, 120)];
    [self.v_pregnancyStatus addSubview:btn2];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"是否在孕期弹层－非@2x_06"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labaa = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame) + 20, SCREEN_WIDTH, 10)];
    [self.v_pregnancyStatus addSubview:labaa];
    [labaa setText:@"or"];
    [labaa setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [labaa setTextAlignment:NSTextAlignmentCenter];
    [labaa setFont:[UIFont systemFontOfSize:10]];
    //    [self.view addSubview:self.v_pregnancyStatus];
    
    //    [self.navigationController.navigationBar setHidden:YES];
    //    [UIView transitionFromView:self.view toView:self.v_pregnancyStatus duration:1.5 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
    //       [self.view bringSubviewToFront:self.v_pregnancyStatus];
    //    }];
    self.v_pregnancyStatus.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:self.v_pregnancyStatus];
    [UIView animateWithDuration:0.3 animations:^{
        self.v_pregnancyStatus.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

-(void)btn1Action{
    self.pregnancyStatus = @"1";
    [self updatePrenancyStatus];
}
-(void)btn2Action{
    self.pregnancyStatus = @"2";
    [self updatePrenancyStatus];
}
-(void)updatePrenancyStatus{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,UpdatePregnancyStatus];
    NSDictionary *dic = @{@"pregnancyStatus":self.pregnancyStatus};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        [self.navigationController.navigationBar setHidden:NO];
        
        if (self.isSetRootView) {
            [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
        }else{
            if (self.notBack) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [self.v_pregnancyStatus removeFromSuperview];
    } fail:^(NSError *error) {
        [self.navigationController.navigationBar setHidden:NO];
        
        if (self.isSetRootView) {
            [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
        }else{
            if (self.notBack) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [self.v_pregnancyStatus removeFromSuperview];
    }];
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
