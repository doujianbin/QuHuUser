//
//  ChangeNickNameViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/18.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "Toast+UIView.h"

@interface ChangeNickNameViewController ()<UITextFieldDelegate>{
    UIButton *btnR;
}

@property (nonatomic ,strong)UITextField *tf_nickName;

@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    UILabel *titleLabel = [[UILabel
                            alloc] initWithFrame:CGRectMake(0,
                                                            0, 150, 44)];
    [titleLabel setText:@"昵称"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 30, 20)];
    [btnl setTitle:@"取消" forState:UIControlStateNormal];
    [btnl setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
    btnl.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 21.5, 30, 24)];
    [btnR setTitle:@"保存" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#a4a4a4"] forState:UIControlStateNormal];
    btnR.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnright;
    btnR.enabled = NO;
    [btnR addTarget:self action:@selector(btnRSaveNickName) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
    UIView *v_lab = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
    [self.view addSubview:v_lab];
    [v_lab setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [v_lab addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#BBBBBB"]];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    [v_lab addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#BBBBBB"]];
    
    self.tf_nickName = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 30, 45)];
    [v_lab addSubview:_tf_nickName];
    _tf_nickName.text = self.nickName;
    self.tf_nickName.delegate = self;
    [self.tf_nickName  setValue:@10 forKey:@"limit"];
    [self.tf_nickName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    self.tf_nickName.font = [UIFont systemFontOfSize:17];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tgrAction)];
    [self.view addGestureRecognizer:tgr];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    btnR.enabled = YES;
    
    if ([string isEqualToString:@"\n"]) {
        if (string.length > 10) {
            self.tf_nickName.text = [string substringToIndex:10];
            [textField resignFirstResponder];
        }
        return NO;
    }
    if (textField == self.tf_nickName) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
        if (string.length < 10) {
            
        }
        if (existedLength - selectedLength + replaceLength == 10) {
            
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnRSaveNickName{
    if (self.tf_nickName.text.length > 0) {
        AFNManager *manager = [[AFNManager alloc]init];
        NSDictionary *dic = @{@"nickName":self.tf_nickName.text};
        NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/savePersonalInfo",Development];
        [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
            if ([Status isEqualToString:SUCCESS]) {
                
                [LoginStorage savenickName:[[responseDic objectForKey:@"data"] objectForKey:@"nickName"]];
                [self.delegate didSelectedNickNameWithStr:self.tf_nickName.text];
                
                [NSTimer scheduledTimerWithTimeInterval:0.5
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
        [self.view makeToast:@"请输入昵称" duration:1.0 position:@"center"];
    }
}

-(void)tgrAction{
    [self.tf_nickName resignFirstResponder];
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
