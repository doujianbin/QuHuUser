//
//  UserInfoDetailViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/2/25.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "Toast+UIView.h"
#import "ChangeNickNameViewController.h"

@interface UserInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,ChangeNickNameControllerDegelate>
@property (nonatomic ,strong)UITableView *tb_userInfo;
@property (nonatomic ,strong)UIButton *btn_headPic;
@property (nonatomic ,strong)UITextField *lab_nickName;
@property (nonatomic ,strong)NSString *strNickName;
@property (nonatomic ,strong)UIImage *iconImage;
@property (nonatomic ,strong)NSDictionary *dataDic;
@property (nonatomic ,strong)NSString *imageString;
@property (nonatomic ,strong)UIView *backV;
@end

@implementation UserInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 21.5, 17, 17)];
//    [btnR setTitle:@"提交" forState:UIControlStateNormal];
//    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
//    [btnR sizeToFit];
//    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc]initWithCustomView:btnR];
//    self.navigationItem.rightBarButtonItem = btnRight;
//    [btnR addTarget:self action:@selector(NavRightAction) forControlEvents:UIControlEventTouchUpInside];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;

    // Do any additional setup after loading the view.
    [self onCreate];
}

- (void)onCreate{
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9.5, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    self.tb_userInfo = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 57 + 75) style:UITableViewStylePlain];
    [self.view addSubview:self.tb_userInfo];
    self.tb_userInfo.delegate = self;
    self.tb_userInfo.dataSource = self;
    self.tb_userInfo.scrollEnabled = NO;
    [self.tb_userInfo registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableView"];
    [self.tb_userInfo setSeparatorColor:[UIColor clearColor]];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 57 + 75 + 73.5- 64, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIView *v_jifen = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img2.frame) + 10, SCREEN_WIDTH, 57)];
    [self.view addSubview:v_jifen];
    [v_jifen setBackgroundColor:[UIColor whiteColor]];
    UILabel *lab_jifen1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 57)];
    [v_jifen addSubview:lab_jifen1];
    [lab_jifen1 setText:@"积分"];
    lab_jifen1.font = [UIFont systemFontOfSize:17];
    [lab_jifen1 setTextColor:[UIColor colorWithHexString:@"#929292"]];
    
    UILabel *lab_jifen2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 0, 70, 57)];
    [v_jifen addSubview:lab_jifen2];
    lab_jifen2.font = [UIFont systemFontOfSize:17];
    [lab_jifen2 setTextColor:[UIColor colorWithHexString:@"#ffc73d"]];
    [lab_jifen2 setTextAlignment:NSTextAlignmentRight];
    [lab_jifen2 setText:self.points];
    
    UIButton *btn_jifenguize = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, CGRectGetMaxY(v_jifen.frame) + 10, 70, 16)];
    [self.view addSubview:btn_jifenguize];
    [btn_jifenguize setTitle:@"积分规则" forState:UIControlStateNormal];
    btn_jifenguize.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn_jifenguize setTitleColor:[UIColor colorWithHexString:@"#4a90e2"] forState:UIControlStateNormal];
    [btn_jifenguize addTarget:self action:@selector(jifenAction) forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 75;
    }
    if (indexPath.row == 1) {
        return 57;
    }
    return 0;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"头像"];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74.5, SCREEN_WIDTH, 0.5)];
        [cell addSubview:img1];
        [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
        
        self.btn_headPic = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 92, 7.5, 60, 60)];
        [cell addSubview:self.btn_headPic];
        self.btn_headPic.layer.cornerRadius = 30.0f;
        self.btn_headPic.layer.masksToBounds = YES;
        NSString *headPath = [LoginStorage Getphoto];
        [self.btn_headPic sd_setBackgroundImageWithURL:[NSURL URLWithString:headPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadPlaceImg"]];
        [self.btn_headPic addTarget:self action:@selector(headPicAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (indexPath.row == 1) {

        [cell.textLabel setText:@"昵称"];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        
        self.lab_nickName = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 215, 17.5, 182, 22.5)];
        [cell addSubview:self.lab_nickName];
        self.lab_nickName.font = [UIFont systemFontOfSize:17];
        self.lab_nickName.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        self.lab_nickName.textAlignment = NSTextAlignmentRight;
        self.lab_nickName.enabled = NO;
        [self.lab_nickName  setValue:@10 forKey:@"limit"];
        self.lab_nickName.delegate = self;
//        NSString *nickName = [LoginStorage GetnickName];
        if (self.nickName.length == 0) {
            self.lab_nickName.placeholder = @"请输入昵称";
        }else{
            self.lab_nickName.text = self.nickName;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.lab_nickName resignFirstResponder];
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择头像上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        sheet.delegate = self;
        [sheet showInView:self.view];
    }
    if (indexPath.row == 1) {
        
//        self.lab_nickName.text = @"";
//        [self.lab_nickName becomeFirstResponder];
        ChangeNickNameViewController *vc = [[ChangeNickNameViewController alloc]init];
        vc.nickName = self.lab_nickName.text;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)headPicAction{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择头像上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        default:
            return;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.iconImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *data = UIImageJPEGRepresentation(self.iconImage, 0.6);
    [self.btn_headPic setBackgroundImage:self.iconImage forState:UIControlStateNormal];
    self.imageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.dataDic = @{@"photo":self.imageString,@"photoExt":@"JPEG"};
    [self uploadData];
    
}

//-(void)NavRightAction{
//    
//    if (self.lab_nickName.text.length > 10) {
//        self.lab_nickName.text = [self.lab_nickName.text substringToIndex:10];
//        [self.lab_nickName resignFirstResponder];
//    }
//    
//    if (self.imageString.length == 0 && self.lab_nickName.text.length == 0) {
//        
//        [self.view makeToast:@"请选择图片或填写昵称" duration:1.0 position:@"center"];
//        return;
//    }if (self.imageString.length == 0 && [[LoginStorage GetnickName] isEqualToString:self.lab_nickName.text]) {
//        [self.view makeToast:@"请选择图片或修改昵称" duration:1.0 position:@"center"];
//        return;
//    }
//    if (self.lab_nickName.text.length > 0 && self.imageString.length > 0) {
//        self.dataDic = @{@"photo":self.imageString,@"photoExt":@"JPEG",@"nickName":self.lab_nickName.text};
//        [self uploadData];
//        return;
//    }if (self.lab_nickName.text.length > 0 && self.imageString.length == 0) {
//        self.dataDic = @{@"nickName":self.lab_nickName.text};
//        [self uploadData];
//        return;
//    }if (self.imageString.length > 0 && self.lab_nickName.text.length == 0) {
//        self.dataDic = @{@"photo":self.imageString,@"photoExt":@"JPEG"};
//        [self uploadData];
//        return;
//    }
//}

-(void)uploadData{
    [self.lab_nickName resignFirstResponder];
    AFNManager *manager = [[AFNManager alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/savePersonalInfo",Development];
    BeginActivity;
    [manager RequestJsonWithUrl:url method:@"POST" parameter:self.dataDic result:^(id responseDic) {
        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            [LoginStorage savephoto:[[responseDic objectForKey:@"data"] objectForKey:@"photo"]];
            [LoginStorage savenickName:[[responseDic objectForKey:@"data"] objectForKey:@"nickName"]];
            [self.btn_headPic sd_setBackgroundImageWithURL:[NSURL URLWithString:[[responseDic objectForKey:@"data"] objectForKey:@"photo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadPlaceImg"]];
            [self.view makeToast:@"提交成功" duration:1.0 position:@"center"];
//            [NSTimer scheduledTimerWithTimeInterval:1.2
//                                             target:self
//                                           selector:@selector(NavLeftAction)
//                                           userInfo:nil
//                                            repeats:NO];
        }else{
            NSString *photoPath = [LoginStorage Getphoto];
            [self.btn_headPic sd_setBackgroundImageWithURL:[NSURL URLWithString:photoPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadPlaceImg"]];
            FailMessage;
        }
        
    } fail:^(NSError *error) {
        NSString *photoPath = [LoginStorage Getphoto];
        [self.btn_headPic sd_setBackgroundImageWithURL:[NSURL URLWithString:photoPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HeadPlaceImg"]];
        EndActivity;
        NetError;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (string.length > 10) {
            self.lab_nickName.text = [string substringToIndex:10];
            [textField resignFirstResponder];
        }
        return NO;
    }
    if (textField == self.lab_nickName) {
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
    if (self.lab_nickName.text.length > 10) {
        [self.lab_nickName setText:[self.lab_nickName.text substringToIndex:10]];
    }
    [self.lab_nickName resignFirstResponder];
    return YES;
}

-(void)jifenAction{
    self.backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view.window addSubview:self.backV];
    [self.backV setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    
    UIImageView *img_fuwu = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.133, SCREEN_HEIGHT * 0.17, SCREEN_WIDTH * 0.734, SCREEN_HEIGHT * 0.562)];
    [self.backV addSubview:img_fuwu];
    [img_fuwu setImage:[UIImage imageNamed:@"积分规则@2x_03"]];
    img_fuwu.layer.cornerRadius = 4.0f;
    img_fuwu.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.backV addGestureRecognizer:tgr];
}

-(void)removeView{
    [self.backV removeFromSuperview];
}

-(void)didSelectedNickNameWithStr:(NSString *)strNickName{
//    self.nickName = strNickName;
    self.lab_nickName.text = strNickName;
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
