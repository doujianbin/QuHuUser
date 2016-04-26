//
//  OpinionViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "OpinionTableViewController.h"
#import "UIBarButtonItem+Extention.h"
#import "OpinionCell.h"
#import "ContactCell.h"
#import "ButtonCell.h"
#import "Toast+UIView.h"
#import "GCPlaceholderTextView.h"
#import "UITextView+ResignKeyboard.h"

@interface OpinionTableViewController ()<UITextViewDelegate>

@property (nonatomic, weak)ContactCell *contactCell;

@property (nonatomic, weak)OpinionCell *opinionCell;

@property (nonatomic ,strong)GCPlaceholderTextView *tf_opinion;

@end


@implementation OpinionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    self.title = @"意见反馈";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidesKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hidesKeyboard {
    
    [self.view endEditing:YES];
}

- (void)backItemClick {
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellId1 = @"cell1";
    NSString *cellId2 = @"cell2";
    NSString *cellId3 = @"cell3";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
    
        self.tf_opinion = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 130)];
        self.tf_opinion.delegate = self;
        [self.tf_opinion setPlaceholder:@"请输入您的意见或者建议"];
        self.tf_opinion.font = [UIFont systemFontOfSize:14];
        [self.tf_opinion setNormalInputAccessory];
        [self.tf_opinion  setValue:@200 forKey:@"limit"];
        [cell addSubview:self.tf_opinion];

        
        return cell;
    }else if (indexPath.section == 1) {
        ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
        
        self.contactCell = cell;
        
        return cell;
    }else if (indexPath.section == 2){
    
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if (cell == nil) {
            cell = [[ButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
        }
        [cell.button setTitle:@"提交" forState:UIControlStateNormal];
        
        [cell.button addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else {
    
        return nil; 
    }
}

- (void)commitButtonClick {

    AFNManager *manager = [[AFNManager alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/saveSuggest",Development];
    
    NSString *contactString = self.contactCell.contactTextField.text;
    NSString *string = self.tf_opinion.text;
    NSLog(@"%@",string);
    NSLog(@"%@",contactString);

    if (string.length < 11) {
        
        [self.view makeToast:@"请输入10字以上意见或建议" duration:1.0 position:@"center"];
    }else if (contactString.length == 0){
        
        [self.view makeToast:@"请输入联系方式" duration:1.0 position:@"center"];
        
    }else {
        BeginActivity;
        NSDictionary *dic = @{@"contact":self.contactCell.contactTextField.text,@"context":string};
        
        [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
            EndActivity;
            if (SUCCESS) {
               
                NSLog(@"~~~~~~success %@",responseDic);
                
                [self.view makeToast:@"提交成功" duration:1.0 position:@"center"];
                [NSTimer scheduledTimerWithTimeInterval:1.2
                                                 target:self
                                               selector:@selector(backItemClick)
                                               userInfo:nil
                                                repeats:NO];
            }
            
        } fail:^(NSError *error) {
            EndActivity;
            NetError;
            NSLog(@"#######fail %@",error);
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    
    if (section == 0) {
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        headerView.backgroundColor = COLOR(245, 246, 247, 1);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5.5, 56, 20)];
        label.text = @"意见反馈";
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = COLOR(155, 155, 155, 1);
        
        [headerView addSubview:label];
        
        return headerView;
        
    }else if (section == 1) {
    
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        headerView.backgroundColor = COLOR(245, 246, 247, 1);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5.5, 84, 20)];
        label.text = @"您的联系方式";
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = COLOR(155, 155, 155, 1);
        
        [headerView addSubview:label];
        
        return headerView;
    }else {
    
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 2) {

        return 70;
    }else {
    
        return 30.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 150;
        
    }else if (indexPath.section == 1) {
        
        return 57;
    }else {
        
        return 44;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ((textView = self.tf_opinion)) {
        if (text.length == 0)
            return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 120) {
            return NO;
        }
        if (text.length < 120) {
            
        }
        if (existedLength - selectedLength + replaceLength == 120) {
            
        }
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.tf_opinion.text.length > 120) {
        self.tf_opinion.text = [self.tf_opinion.text substringToIndex:120];
    }
    return YES;
}



@end
