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

@interface MakeBillTableViewController ()

@property (nonatomic, strong)NSArray *billArray;

@property (nonatomic, strong)NSArray *personArray;


@end

@implementation MakeBillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"按开票历史";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
    }else if (section == 1){
    
        return 3;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId1 = @"cell1";
    NSString *cellId2 = @"cell2";
    NSString *cellId3 = @"cell3";
    
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
    if (section == 0 || section == 1) {
        MakeBillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[MakeBillCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        if (section == 0) {
            
            cell.titleLabel.text = self.billArray[indexPath.row];
        }else {
            
            cell.titleLabel.text = self.personArray[indexPath.row];
        }
        
        return cell;
    }else if (section == 2) {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[ButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
        
        [cell.button setTitle:@"提交" forState:UIControlStateNormal];
        
        return cell;
    }else {
        CharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if (cell == nil) {
            cell = [[CharacterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
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
    
    if (section == 0 || section == 1) {
        return 54;
    }else if (section == 2) {
        return 44;
    }else {
        return 19;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0 || section == 1) {
        
        return 10;
    }else if (section == 2) {
        
        return 30;
    }else {
        
        return 6;
    }
}

- (NSArray *)billArray {
    if (!_billArray) {
        _billArray = [NSArray arrayWithObjects:@"开票金额",@"开票抬头",@"开票内容", nil];
    }
    return _billArray;
}

- (NSArray *)personArray {
    if (!_personArray) {
        _personArray = [NSArray arrayWithObjects:@"收件人",@"收件电话",@"地址", nil];
    }
    return _personArray;
}

@end
