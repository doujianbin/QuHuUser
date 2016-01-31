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

@interface OpinionTableViewController ()

@property (nonatomic, weak)ContactCell *contactCell;

@property (nonatomic, weak)OpinionCell *opinionCell;

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
        OpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[OpinionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
    
        self.opinionCell = cell;
        
        return cell;
    }else if (indexPath.section == 1) {
        ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
        
        self.contactCell = cell;
        
        return cell;
    }else {
    
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if (cell == nil) {
            cell = [[ButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
        }
        [cell.button setTitle:@"提交" forState:UIControlStateNormal];
        
        [cell.button addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)commitButtonClick {

    AFNManager *manager = [AFNManager shareManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/saveSuggest",Development];
    
    NSString *contactString = self.contactCell.contactTextField.text;
    NSLog(@"%@",contactString);
//    NSString *contextString = 

    NSDictionary *dic = @{@"contact":self.contactCell.contactTextField.text};
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
        
        NSLog(@"~~~~~~success %@",responseDic);
        
    } fail:^(NSError *error) {
        
        NSLog(@"#######fail %@",error);
    }];
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

@end
