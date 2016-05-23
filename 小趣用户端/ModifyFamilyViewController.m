//
//  ModifyFamilyViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ModifyFamilyViewController.h"
#import "AddFamilyTableViewCell.h"
#import "Toast+UIView.h"

@interface ModifyFamilyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    UITableView *tableAddFamily;
    NSMutableArray *arr;
    UITextField *tef_name;
    UILabel *lab_relation;
    UITextField *tef_PhoneNum;
    UITextField *tef_IdCard;
    UIButton *btn_gender_man;
    UIButton *btn_gender_women;
}
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)NSString * genderIndex;

@end



@implementation ModifyFamilyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        arr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"性别",@"关系",@"手机",@"身份证", nil];
        arr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"性别",@"手机",@"身份证", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.title = @"修改就诊人";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 10, 30, 24)];
    [btnR setTitle:@"更新" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    btnR.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnright;
    [btnR addTarget:self action:@selector(btnRSave) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    [self addFamilyTableView];
}


-(void)addFamilyTableView{
    tableAddFamily = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 57 * 4 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableAddFamily];
    [tableAddFamily setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    tableAddFamily.delegate = self;
    tableAddFamily.dataSource = self;
    tableAddFamily.rowHeight = 57;
    tableAddFamily.scrollEnabled = NO;
    tableAddFamily.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableAddFamily registerClass:[AddFamilyTableViewCell class] forCellReuseIdentifier:@"tableViewAddFamily"];
    if ([self.memberEntity.sex isEqualToString:@"男"]) {
        self.genderIndex = @"0";
    }else{
        self.genderIndex = @"1";
    }
    
    UILabel *lab_tixing = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tableAddFamily.frame) + 10 - 64 - 7, SCREEN_WIDTH - 30, 70)];
    lab_tixing.numberOfLines = 0;
    [self.view addSubview:lab_tixing];
    NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"陪诊服务中我们会为就诊人免费提供一份平安意外险，请输入您的真实身份信息(姓名、性别、身份证号码)，信息有误会影响您的保险生效。"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [myStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [myStr length])];
    
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a4a4a4"] range:NSMakeRange(0, 12)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 12)];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(12, 36)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(12, 36)];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a4a4a4"] range:NSMakeRange(48, 15)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(48, 15)];
    [lab_tixing setAttributedText:myStr];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewAddFamily"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.lab_left setText:[arr objectAtIndex:indexPath.row]];
    if (indexPath.row == 0) {
        tef_name = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 21, 100, 16.5)];
        [cell addSubview:tef_name];
        tef_name.font = [UIFont systemFontOfSize:16];
        tef_name.textAlignment = NSTextAlignmentRight;
        tef_name.delegate = self;
        tef_name.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [tef_name setText:self.memberEntity.userName];
    }
    if (indexPath.row == 1) {
        btn_gender_man = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 151, 17.5, 22, 22)];
        [cell addSubview:btn_gender_man];
//        [btn_gender_man setImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
        
        UILabel *labnan = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 117, 18, 15, 21)];
        [cell addSubview:labnan];
        [labnan setText:@"男"];
        labnan.font = [UIFont systemFontOfSize:15];
        labnan.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [btn_gender_man addTarget:self action:@selector(btnnanAction) forControlEvents:UIControlEventTouchUpInside];
        
        btn_gender_women = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 17.5, 22, 22)];
        [cell addSubview:btn_gender_women];
//        [btn_gender_women setImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
        UILabel *labnv = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 36, 18, 15, 21)];
        [cell addSubview:labnv];
        [labnv setText:@"女"];
        labnv.font = [UIFont systemFontOfSize:15];
        labnv.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [btn_gender_women addTarget:self action:@selector(btnnvAction) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.memberEntity.sex isEqualToString:@"男"]) {
            //男
            [btn_gender_man setImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
            [btn_gender_women setImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
        }else{
            // 女
            [btn_gender_women setImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
            [btn_gender_man setImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
        }
        
    }
//    if (indexPath.row == 2) {
//        lab_relation = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 21, 100, 16.5)];
//        [cell addSubview:lab_relation];
//        lab_relation.font = [UIFont systemFontOfSize:16];
//        lab_relation.textAlignment = NSTextAlignmentRight;
//        lab_relation.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
//        [lab_relation setText:self.memberEntity.relation];
//        
//    }
    if (indexPath.row == 2) {
        tef_PhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 215, 20.5, 200, 16.5)];
        [cell addSubview:tef_PhoneNum];
        tef_PhoneNum.font = [UIFont systemFontOfSize:16];
        tef_PhoneNum.textAlignment = NSTextAlignmentRight;
        tef_PhoneNum.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        tef_PhoneNum.keyboardType = UIKeyboardTypeNumberPad;
        tef_PhoneNum.delegate = self;
        [tef_PhoneNum setNormalInputAccessory];
        tef_PhoneNum.text = self.memberEntity.phoneNumber;
    }
    if (indexPath.row == 3) {
        tef_IdCard = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 235, 20.5, 220, 16.5)];
        [cell addSubview:tef_IdCard];
        tef_IdCard.font = [UIFont systemFontOfSize:16];
        tef_IdCard.textAlignment = NSTextAlignmentRight;
        tef_IdCard.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        tef_IdCard.delegate = self;
        tef_IdCard.keyboardType = UIKeyboardTypeNumbersAndPunctuation;// 身份证专用样式
        tef_IdCard.enabled = NO;
        tef_IdCard.text = self.memberEntity.idNo;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [tef_name becomeFirstResponder];
    }
//    if (indexPath.row == 2) {
//        [tef_name resignFirstResponder];
//        [tef_IdCard resignFirstResponder];
//        [tef_PhoneNum resignFirstResponder];
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:nil
//                                      delegate:self
//                                      cancelButtonTitle:@"取消"
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:@"父母", @"子女",@"亲属",@"朋友",@"自己",@"其他",nil];
//        actionSheet.actionSheetStyle = UIBarStyleDefault;
//        [actionSheet showInView:self.view];
//    }
    if (indexPath.row == 2) {
        [tef_PhoneNum becomeFirstResponder];
    }
    if (indexPath.row == 3) {
        [tef_IdCard becomeFirstResponder];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [lab_relation setText:@"父母"];
    }else if (buttonIndex == 1) {
        [lab_relation setText:@"子女"];
    }else if(buttonIndex == 2) {
        [lab_relation setText:@"亲属"];
    }else if(buttonIndex == 3) {
        [lab_relation setText:@"朋友"];
    }
    else if(buttonIndex == 4) {
        [lab_relation setText:@"自己"];
    }else if(buttonIndex == 5) {
        [lab_relation setText:@"其他"];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [tef_name resignFirstResponder];
    [tef_IdCard resignFirstResponder];
    return YES;
}

-(void)btnnanAction{
    [btn_gender_man setImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
    [btn_gender_women setImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
    self.genderIndex = @"0";
}


-(void)btnnvAction{
    [btn_gender_man setImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
    [btn_gender_women setImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
    self.genderIndex = @"1";
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnRSave{
    if (tef_name.text.length == 0) {
        [self.view makeToast:@"请输入姓名" duration:1.0 position:@"center"];
        return;
    }
//    if (lab_relation.text.length == 0) {
//        [self.view makeToast:@"请选择关系" duration:1.0 position:@"center"];
//        return;
//    }
    if (tef_PhoneNum.text.length == 0) {
        [self.view makeToast:@"请输入手机号" duration:1.0 position:@"center"];
        return;
    }
    if (tef_PhoneNum.text.length != 11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:@"center"];
        return;
    }
    if (tef_IdCard.text.length == 0) {
        [self.view makeToast:@"请输入身份证号" duration:1.0 position:@"center"];
    }else{
        [self upLoadMember];
        BeginActivity;
    }
}

-(void)upLoadMember{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,UpdateFamily];
    NSDictionary *dic = @{@"userName":tef_name.text,@"sex":self.genderIndex,@"phoneNumber":tef_PhoneNum.text,@"idNo":tef_IdCard.text,@"id":self.memberEntity.userId};
    
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"%@",responseDic);
        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            FailMessage;
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(NavLeftAction)
                                           userInfo:nil
                                            repeats:NO];
            
        }else{
            FailMessage;
        }
        
    } fail:^(NSError *error) {
        NetError;
        EndActivity;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tef_name) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
        if (string.length < 10) {
//            NSLog(@"小于11");
        }
        if (existedLength - selectedLength + replaceLength == 10) {
            
//            NSLog(@"等于11");
        }
    }
    if (textField == tef_PhoneNum) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
        if (string.length < 11) {
//            NSLog(@"小于11");
        }
        if (existedLength - selectedLength + replaceLength == 11) {
            
//            NSLog(@"等于11");
        }
    }
    if (textField == tef_IdCard) {
        if (string.length == 0)
            return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
        if (string.length < 18) {
//            NSLog(@"小于11");
        }
        if (existedLength - selectedLength + replaceLength == 18) {
            
//            NSLog(@"等于11");
        }
    }
    
    return YES;
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
