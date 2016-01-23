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

@interface OpinionTableViewController ()

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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellId1 = @"cell1";
    NSString *cellId2 = @"cell2";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[OpinionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    headerView.backgroundColor = COLOR(245, 246, 247, 1);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 150;
        
    }else {
        
        return 57;
    }
}

@end
