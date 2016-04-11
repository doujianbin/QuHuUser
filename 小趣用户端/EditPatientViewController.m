//
//  EditPatientViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/16.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "EditPatientViewController.h"
#import "GCPlaceholderTextView.h"
#import "PatientPictureView.h"
#import "ImageUtil.h"
#import "Toast+UIView.h"
#import "NSString+Size.h"

@interface EditPatientViewController ()<UITextFieldDelegate,UITextViewDelegate,PatientPictureViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,strong)UIScrollView *sc_back;
@property (nonatomic ,strong)UITextField *tf_doctor;
@property (nonatomic ,strong)UITextField *tf_department;
@property (nonatomic ,strong)UITextField *tf_diagnosis;
@property (nonatomic ,strong)NSMutableArray *arr_pics;
@property (nonatomic, strong)PatientPictureView *pictureView;
@property (nonatomic ,strong)GCPlaceholderTextView *tf_diseaseDescription;
@property (nonatomic ,strong)NSDictionary *postDic;

@end

@implementation EditPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑档案";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 10, 30, 24)];
    [btnR setTitle:@"保存" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    btnR.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnright;
    [btnR addTarget:self action:@selector(btnSave) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    [self onCreate];
}

-(void)onCreate{
    
    self.sc_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.sc_back];
    
    UILabel *lb_timeAndHospital = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, SCREEN_WIDTH - 30, 0)];
    [self.sc_back addSubview:lb_timeAndHospital];
    lb_timeAndHospital.numberOfLines = 0;
    lb_timeAndHospital.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    NSString *time = [self.entity.serviceTime substringToIndex:16];
    NSString *str_hospital = [NSString stringWithFormat:@"%@  %@",time,self.entity.hospitalName];
    [lb_timeAndHospital setText:str_hospital];
    CGFloat height = [str_hospital fittingLabelHeightWithWidth:lb_timeAndHospital.frame.size.width andFontSize:[UIFont systemFontOfSize:17]];
    [lb_timeAndHospital setFrame:CGRectMake(15, 12, SCREEN_WIDTH - 30, height)];
    
    UIImageView *img_doctor = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lb_timeAndHospital.frame) + 20, 16, 16)];
    [self.sc_back addSubview:img_doctor];
    [img_doctor setImage:[UIImage imageNamed:@"1.3档案页@2x_03"]];
    
    self.tf_doctor = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_doctor.frame) + 11, CGRectGetMaxY(lb_timeAndHospital.frame) + 21, SCREEN_WIDTH - CGRectGetMaxX(img_doctor.frame) - 30, 16)];
    [self.sc_back addSubview:self.tf_doctor];
    if (self.entity.doctorName.length > 0) {
        [self.tf_doctor setText:self.entity.doctorName];
    }else{
        
        [self.tf_doctor setPlaceholder:@"医生"];
    }
    self.tf_doctor.delegate = self;
    self.tf_doctor.font = [UIFont systemFontOfSize:16];
    [self.tf_doctor setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    UIImageView *imgline1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tf_doctor.frame) + 12.5, SCREEN_WIDTH, 0.5)];
    [self.sc_back addSubview:imgline1];
    [imgline1 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UIImageView *img_department = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline1.frame) + 12.5, 16, 16)];
    [self.sc_back addSubview:img_department];
    [img_department setImage:[UIImage imageNamed:@"1.3档案页@2x_06"]];
    
    self.tf_department = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_department.frame) + 11, CGRectGetMaxY(imgline1.frame) + 13.5, SCREEN_WIDTH - CGRectGetMaxX(img_department.frame) - 40, 16)];
    [self.sc_back addSubview:self.tf_department];
    if (self.entity.deptName.length > 0) {
        [self.tf_department setText:self.entity.deptName];
    }else{
        
        [self.tf_department setPlaceholder:@"科室"];
    }
    self.tf_department.delegate = self;
    [self.tf_department setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    self.tf_department.font = [UIFont systemFontOfSize:16];
    
    UIImageView *imgline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tf_department.frame) + 12.5, SCREEN_WIDTH, 0.5)];
    [self.sc_back addSubview:imgline2];
    [imgline2 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UIImageView *img_diagnosis = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline2.frame) + 12.5, 16, 16)];
    [self.sc_back addSubview:img_diagnosis];
    [img_diagnosis setImage:[UIImage imageNamed:@"1.3档案页@2x_08"]];
    
    self.tf_diagnosis = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_diagnosis.frame) + 11, CGRectGetMaxY(imgline2.frame) + 13.5, SCREEN_WIDTH - CGRectGetMaxX(img_diagnosis.frame) - 40, 16)];
    [self.sc_back addSubview:self.tf_diagnosis];
    if (self.entity.diagnosis.length > 0) {
        [self.tf_diagnosis setText:self.entity.diagnosis];
    }else{
        
        [self.tf_diagnosis setPlaceholder:@"诊断"];
    }
    self.tf_diagnosis.delegate = self;
    self.tf_diagnosis.font = [UIFont systemFontOfSize:16];
    [self.tf_diagnosis setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    
    UIImageView *imgline3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tf_diagnosis.frame) + 12.5, SCREEN_WIDTH, 0.5)];
    [self.sc_back addSubview:imgline3];
    [imgline3 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UIImageView *img_diseaseDescription = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline3.frame) + 12.5, 16, 16)];
    [self.sc_back addSubview:img_diseaseDescription];
    [img_diseaseDescription setImage:[UIImage imageNamed:@"1.3档案页@2x_10"]];
    
    self.tf_diseaseDescription = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_diseaseDescription.frame) + 7, CGRectGetMaxY(imgline3.frame) + 3, SCREEN_WIDTH - CGRectGetMaxX(img_diagnosis.frame) - 15, 16 * 5)];
    [self.sc_back addSubview:self.tf_diseaseDescription];
    if (self.entity.diseaseDescription.length > 0) {
        [self.tf_diseaseDescription setText:self.entity.diseaseDescription];
    }else{
        
        [self.tf_diseaseDescription setPlaceholder:@"病情描述"];
    }
    [self.tf_diseaseDescription setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
    self.tf_diseaseDescription.delegate = self;
    self.tf_diseaseDescription.font = [UIFont systemFontOfSize:16];
    
    UIImageView *imgline4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tf_diseaseDescription.frame) + 12.5, SCREEN_WIDTH, 0.5)];
    [self.sc_back addSubview:imgline4];
    [imgline4 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UILabel *lb_sctp = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline4.frame) + 20, 80, 17)];
    [self.sc_back addSubview:lb_sctp];
    [lb_sctp setText:@"上传图片"];
    lb_sctp.font = [UIFont systemFontOfSize:17];
    [lb_sctp setTextColor:[UIColor colorWithHexString:@"4A4A4A"]];
    
    UILabel *lb_detail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb_sctp.frame) - 5, CGRectGetMaxY(imgline4.frame) + 24, SCREEN_WIDTH - CGRectGetMaxX(lb_sctp.frame) - 25, 13)];
    [self.sc_back addSubview:lb_detail];
    [lb_detail setText:@"症状部位，报告或往期就诊资料"];
    [lb_detail setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [lb_detail setFont:[UIFont systemFontOfSize:12]];
    
    // 图片
    
    self.pictureView = [[PatientPictureView alloc]init];
    self.pictureView.delegate = self;
    [self.sc_back addSubview:self.pictureView];
    self.pictureView.isEdit = YES;
    self.arr_pics = [NSMutableArray arrayWithArray:self.entity.pics];
    [self.pictureView loadCollectionViewWithPicturesArray:self.arr_pics withOrifinY:CGRectGetMaxY(lb_detail.frame) + 10];
    [self.pictureView.v_line setHidden:YES];
    [self.sc_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.pictureView.frame) + 20)];
    
}
- (void)deletePictureWithIndex:(int)index{
    [self.arr_pics removeObjectAtIndex:index];
    [self.pictureView loadCollectionViewWithPicturesArray:self.arr_pics withOrifinY:self.pictureView.frame.origin.y];
    [self.sc_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.pictureView.frame) + 20)];
}

- (void)addPicture{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择头像上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
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
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.arr_pics addObject:image];
    [self.pictureView loadCollectionViewWithPicturesArray:self.arr_pics withOrifinY:self.pictureView.frame.origin.y];
    [self.sc_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.pictureView.frame) + 20)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if ((textView = self.tf_diseaseDescription)) {
        if (text.length == 0)
            return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 200) {
            return NO;
        }
        if (text.length < 200) {
            
        }
        if (existedLength - selectedLength + replaceLength == 200) {
            
        }
    }
    return YES;
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnSave{
    
    NSMutableArray *arr_url = [[NSMutableArray alloc]init];
    NSMutableArray *arr_img = [[NSMutableArray alloc]init];
    
    for (id imgData in self.arr_pics) {
        if ([imgData isKindOfClass:[NSString class]]) {
            [arr_url addObject:imgData];
        }else if ([imgData isKindOfClass:[UIImage class]]) {
            [arr_img addObject:imgData];
        }
    }
    NSMutableArray *arr_imgStr = [[NSMutableArray alloc]init];
    for (UIImage * img in arr_img) {
        UIImage *image = [ImageUtil imageWithCompressImage:img];
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        NSString *imgStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [arr_imgStr addObject:imgStr];
    }
    NSLog(@"原有的的 ＝ %@",arr_url);
    NSLog(@"添加的 ＝ %lu",(unsigned long)arr_imgStr.count);
    
    NSString *doctorName;
    NSString *depart;
    NSString *diagnosis;
    NSString *diseaseDescription;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,UpdatePatientRecords];
    if (self.tf_doctor.text.length > 0) {
        doctorName = self.tf_doctor.text;
    }else{
        doctorName = @"";
    }
    if (self.tf_department.text.length > 0) {
        depart = self.tf_department.text;
    }else{
        depart = @"";
    }
    if (self.tf_diagnosis.text.length > 0) {
        diagnosis = self.tf_diagnosis.text;
    }else{
        diagnosis = @"";
    }
    if (self.tf_diseaseDescription.text.length > 0) {
        diseaseDescription = self.tf_diseaseDescription.text;
    }else{
        diseaseDescription = @"";
    }
    self.postDic = @{@"id":self.entity.patientId,@"photoExt":@"png",@"deptName":depart,@"doctorName":doctorName,@"diagnosis":diagnosis,@"diseaseDescription":diseaseDescription,@"existPics":arr_url,@"uploadPics":arr_imgStr};
    [self.view makeToastActivity];
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:self.postDic result:^(id responseDic) {
        [self.view hideToastActivity];
        if ([Status isEqualToString:SUCCESS]) {
            [self.view makeToast:Message duration:1.0 position:@"center"];
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(NavLeftAction)
                                           userInfo:nil
                                            repeats:NO];
            PatientDetailEntity *entity = [PatientDetailEntity parsePatientDetailEntityWithJson:[responseDic objectForKey:@"data"]];
            [self.delegate refreshDataWithPatientDetailEntity:entity];
        }else{
            [self.view makeToast:Message duration:1.0 position:@"center"];
        }
    } fail:^(NSError *error) {
        [self.view hideToastActivity];
        NetError;
    }];
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
