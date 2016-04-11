//
//  ChangeMyDataViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ChangeMyDataViewController.h"

#import "UIBarButtonItem+Extention.h"
#import "Toast+UIView.h"

@interface ChangeMyDataViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak)UILabel *nickNameLabel;

@property (nonatomic, strong)UIButton *iconButton;

@end

@implementation ChangeMyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    [self setupInterface];
    
}


- (void)setupInterface {
  
//头像
    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, [UIScreen mainScreen].bounds.size.width, 75)];
    iconView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iconView];
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 36, 25)];
    iconLabel.adjustsFontSizeToFitWidth = YES;
    iconLabel.text = @"头像";
    iconLabel.textColor = COLOR(150, 150, 150, 1);
    [iconView addSubview:iconLabel];
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 89, 7.5, 60, 60);
    [iconButton setImage:self.personImage forState:UIControlStateNormal];
    [iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [iconView addSubview:iconButton];
    self.iconButton = iconButton;
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 19, 33.5, 4, 8)];
    arrowImageView.contentMode = UIViewContentModeScaleToFill;
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [iconView addSubview:arrowImageView];
    
//昵称
    UIView *nicknameView = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, [UIScreen mainScreen].bounds.size.width, 57)];
    nicknameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nicknameView];
    [self addTapGestureWithView:nicknameView action:@selector(nicknameViewClick)];
    
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 36, 25)];
    nickLabel.adjustsFontSizeToFitWidth = YES;
    nickLabel.text = @"昵称";
    nickLabel.textColor = COLOR(150, 150, 150, 1);
    [nicknameView addSubview:nickLabel];
    
    UILabel *nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 95, 17.5, 80, 22.5)];
    nickNameLabel.textColor = [UIColor blackColor];
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.text = self.personName;
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    [nicknameView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTapGestureWithView:(UIView*)view action:(SEL)action{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [view addGestureRecognizer:tapGesture];
}

- (void)iconButtonClick:(UIButton *)button {

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择头像上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self.view];
}

- (void)nicknameViewClick {

    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertview show];
}



#pragma mark 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 1) {
        BeginActivity;
        self.nickNameLabel.text = textField.text;
        
        AFNManager *manager = [[AFNManager alloc]init];
        
        NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/savePersonalInfo",Development];
        
        NSDictionary *dic = @{@"nickName":self.nickNameLabel.text};
        
        [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
            
            if ([[responseDic objectForKey:@"status"]isEqualToString:SUCCESS]) {
                
                NSLog(@"%@",responseDic);
                
//                [SVProgressHUD showSuccessWithStatus:Message];
            }else {
                
//                [SVProgressHUD showErrorWithStatus:Message];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }
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
    
    UIImage *iconImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self.iconButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    
    AFNManager *manager = [[AFNManager alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/savePersonalInfo",Development];
    
    NSData *data = UIImageJPEGRepresentation(iconImage, 0.6);
    NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *dic = @{@"photo":imageString,@"photoExt":@"JPEG"};
    BeginActivity;
    [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
        
        [self.view makeToast:Message duration:1.0 position:@"center"];
        
    } fail:^(NSError *error) {
        
        EndActivity;
        NetError;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

@end






