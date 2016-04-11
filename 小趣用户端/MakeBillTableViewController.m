//
//  MakeBillTableViewController.m
//  小趣用户端
//
//  Created by 刘伟 on 16/1/26.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MakeBillTableViewController.h"

#import "MakeBillCell.h"
#import "CharacterCell.h"
#import "ButtonCell.h"
#import "UIBarButtonItem+Extention.h"
#import "Toast+UIView.h"
#import "BillHistoryTableViewController.h"
#import "BillRecordTableViewController.h"

@interface MakeBillTableViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy)NSString *billHeader;
@property (nonatomic, copy)NSString *billContent;
@property (nonatomic, copy)NSString *phoneNumber;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *recipientName;

@property (nonatomic, weak)billHeaderCell *billHeaderCell;
@property (nonatomic, weak)billContentCell *billContentCell;
@property (nonatomic, weak)phoneNumberCell *phoneNumberCell;
@property (nonatomic, weak)addressCell *addressCell;
@property (nonatomic, weak)recipientNameCell *recipientNameCell;

@end

@implementation MakeBillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"按开票历史";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    NSLog(@"billIdArray --->>>>>>%@",self.billIdArray);
    
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId1 = @"cell1";
    NSString *cellId2 = @"cell2";
    NSString *cellId3 = @"cell3";
    NSString *cellId4 = @"cell4";
    NSString *cellId5 = @"cell5";
    NSString *cellId6 = @"cell6";
    NSString *cellId7 = @"cell7";
    NSString *cellId8 = @"cell8";
    
    NSInteger section = indexPath.section;
    
    if (section == 0 ) {
        MakeBillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[MakeBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        
        cell.titleLabel.text = @"开票金额";
        
        NSString *string = [NSString stringWithFormat:@"%.2f元",self.totalPrice];
        cell.detailtextField.text = string;
        cell.detailtextField.userInteractionEnabled = NO;
        [cell.detailtextField setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        
        return cell;
        
    }else if (section == 1){
        
        billHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[billHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
        
        cell.titleLabel.text = @"开票抬头";
        cell.detailtextField.placeholder = @"请输入开票抬头";
        
        [cell.detailtextField addTarget:self action:@selector(getbillHeaderText:) forControlEvents:UIControlEventEditingChanged];
        
        self.billHeader = cell.detailtextField.text;
        
        self.billHeaderCell = cell;
        
        return cell;
    }else if (section == 2){
        
        billContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if (cell == nil) {
            cell = [[billContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
        }
        
        [cell.detailtextField addTarget:self action:@selector(getbillContentText:) forControlEvents:UIControlEventEditingChanged];
        
        cell.titleLabel.text = @"开票内容";
        cell.detailtextField.placeholder = @"请输入开票内容";
        
        self.billContentCell = cell;
        
        return cell;
    }else if (section == 3){
        
        recipientNameCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId4];
        if (cell == nil) {
            cell = [[recipientNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId4];
        }
        
        cell.titleLabel.text = @"收件人";
        cell.detailtextField.placeholder = @"请输入姓名";
        
        [cell.detailtextField addTarget:self action:@selector(getrecipientNameText:) forControlEvents:UIControlEventEditingChanged];
        
        self.recipientNameCell = cell;
        
        return cell;
    }else if (section == 4){
        
        phoneNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId5];
        if (cell == nil) {
            cell = [[phoneNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId5];
        }
        
        cell.titleLabel.text = @"收件电话";
        cell.detailtextField.placeholder = @"请输入电话";
        
        [cell.detailtextField addTarget:self action:@selector(getphoneNumberText:) forControlEvents:UIControlEventEditingChanged];
        
        self.phoneNumberCell = cell;
        
        return cell;
    }else if (section == 5){
        
        addressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId6];
        if (cell == nil) {
            cell = [[addressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId6];
        }
        
        cell.titleLabel.text = @"地址";
        cell.detailtextField.placeholder = @"请输入地址";
        cell.detailtextField.delegate = self;
        [cell.detailtextField addTarget:self action:@selector(getaddressText:) forControlEvents:UIControlEventEditingChanged];
        
        self.addressCell = cell;
        
        return cell;
    }else if (section == 6) {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId7];
        if (cell == nil) {
            cell = [[ButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId7];
        }
        
        [cell.button setTitle:@"提交" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else {
        CharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId8];
        if (cell == nil) {
            cell = [[CharacterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId8];
        }
        
        cell.characterLabel.text = @"提交后不可修改，请仔细核对！";
        
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    headerView.backgroundColor = COLOR(245, 246, 247, 1);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    
    if (section == 0 || section == 1 || section == 2 ||section == 3 || section == 4 || section == 5 || section == 6) {
        
        return 57;
    }else if (section == 7 ) {
        
        return 44;
    }else {
        
        return 19;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 ) {
        return 10.5;
    }else if (section == 1 ||section == 2 ) {
        return 0;
    }else if(section == 3){
        return 10;
    }else if (section == 4 || section == 5){
        
        return 0;
    }else if (section == 6){
        
        return 30;
    }else {
        return 6;
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 102) {
        
        if (buttonIndex == 1) {
            BeginActivity;
            AFNManager *manager = [[AFNManager alloc]init];
            
            NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/invoice/issueInvoice",Development];
            NSDictionary *dic = @{@"billHeader":self.billHeader,@"orderIds":self.billIdArray,@"billContent":self.billContent ,@"phoneNumber":self.phoneNumber ,@"address":self.address ,@"recipientName":self.recipientName };
            
            [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
                EndActivity;
                if ([Status isEqualToString:SUCCESS]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"开票金我们已受到您的开票需求，会按开票内容向您邮寄发票，发票将在1-3个工作日寄出" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 101;
                    [alert show];
                }else{
                    
                    [self.view makeToast:Message duration:1.0 position:@"center"];
                }
                
            } fail:^(NSError *error) {
                EndActivity;
                NetError;
                
            }];
        }
    }else{
        if (buttonIndex == 0) {
            
            BillRecordTableViewController *vc = [[BillRecordTableViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isFromKaifapiao = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

#pragma mark - submitButtonClick
- (void)submitButtonClick {
    

    if (self.billHeader.length == 0) {
        [self.view makeToast:@"请输入开票抬头" duration:1.0 position:@"center"];
        return;
    }
    if (self.billContent.length == 0) {
        [self.view makeToast:@"请输入开票内容" duration:1.0 position:@"center"];
        return;
    }
    if (self.recipientName.length == 0) {
        [self.view makeToast:@"请输入收件人" duration:1.0 position:@"center"];
        return;
    }
    if (self.phoneNumber.length == 0) {
        [self.view makeToast:@"请输入收件电话" duration:1.0 position:@"center"];
        return;
    }
    if (self.address.length == 0) {
        [self.view makeToast:@"请输入地址" duration:1.0 position:@"center"];
        return;
    }
    if (self.totalPrice < 200) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"开票金额小于200元，需支付快递费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"货到付款", nil];
        alert.tag = 102;
        alert.delegate = self;
        [alert show];
        return;
    }
    else {
        BeginActivity;
        AFNManager *manager = [[AFNManager alloc]init];
        
        NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/invoice/issueInvoice",Development];
        NSDictionary *dic = @{@"billHeader":self.billHeader,@"orderIds":self.billIdArray,@"billContent":self.billContent ,@"phoneNumber":self.phoneNumber ,@"address":self.address ,@"recipientName":self.recipientName };
        
        [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
            EndActivity;
            [self.view makeToast:Message duration:1.0 position:@"center"];
            [NSTimer scheduledTimerWithTimeInterval:1.2
                                             target:self
                                           selector:@selector(SuccessAction)
                                           userInfo:nil
                                            repeats:NO];
            
        } fail:^(NSError *error) {
            EndActivity;
            NetError;
            
        }];
    }
    
    
}

-(void)SuccessAction{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)getbillHeaderText:(UITextField *)text {
    
    self.billHeader = text.text;
    NSLog(@"billHeader%@",self.billHeader);
    
}

- (void)getbillContentText:(UITextField *)text {
    
    self.billContent = text.text;
    NSLog(@"billContent%@",self.billContent);
    
}

- (void)getaddressText:(UITextField *)text {
    
    self.address = text.text;
    NSLog(@"address%@",self.address);
    
}

- (void)getrecipientNameText:(UITextField *)text {
    
    self.recipientName = text.text;
    NSLog(@"recipientName%@",self.recipientName);
}

- (void)getphoneNumberText:(UITextField *)text {
    
    self.phoneNumber = text.text;
    NSLog(@"phoneNumber%@",self.phoneNumber);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
