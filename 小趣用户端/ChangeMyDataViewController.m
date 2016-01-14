//
//  ChangeMyDataViewController.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ChangeMyDataViewController.h"

#import "UIBarButtonItem+Extention.h"

@interface ChangeMyDataViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak)UILabel *nickNameLabel;

@property (nonatomic, weak)UIImageView *iconImageView;

@end

@implementation ChangeMyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = COLOR(219, 220, 221, 1);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//头像
    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, [UIScreen mainScreen].bounds.size.width, 75)];
    iconView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iconView];
    [self addTapGestureWithView:iconView action:@selector(iconViewClick)];
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 36, 25)];
    iconLabel.adjustsFontSizeToFitWidth = YES;
    iconLabel.text = @"头像";
    iconLabel.textColor = COLOR(150, 150, 150, 1);
    [iconView addSubview:iconLabel];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 89, 7.5, 60, 60)];
//    iconImageView.image = [UIImage imageNamed:@"member"];
    iconImageView.contentMode = UIViewContentModeScaleToFill;
    [iconView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
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
    NSString *nickname = [[NSUserDefaults standardUserDefaults]stringForKey:@"nickname"];
    nickNameLabel.text = nickname;
    nickNameLabel.textColor = [UIColor blackColor];
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    self.nickNameLabel = nickNameLabel;
    [nicknameView addSubview:nickNameLabel];
    
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTapGestureWithView:(UIView*)view action:(SEL)action{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [view addGestureRecognizer:tapGesture];
}

- (void)nicknameViewClick {

    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertview show];
}

- (void)iconViewClick {

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.view];
}

#pragma mark 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 1) {
        self.nickNameLabel.text = textField.text;
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"nickname"];
        if ([self.delegate respondsToSelector:@selector(changeMyDataViewControllerDidChangeName:)]) {
            [self.delegate changeMyDataViewControllerDidChangeName:textField.text];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        NSLog(@"xiangce");
    }else {
        NSLog(@"quxiao");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    [[NSUserDefaults standardUserDefaults]setObject:iconImage forKey:@"image"];
    
    
//    UIImage *image = [[NSUserDefaults standardUserDefaults]objectForKey:@"icmage"];
    
    [self saveImage:iconImage withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    self.iconImageView.image = iconImage;
    
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

@end






