//
//  SettingTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SettingTableViewController.h"

#import "SettingCell.h"
#import "UIBarButtonItem+Extention.h"

#import "OpinionTableViewController.h"

@interface SettingTableViewController ()

@property (nonatomic, strong)NSArray *settingDetailArray;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backItemClick {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 界面设置相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"cell";
    
    SettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (settingCell == nil) {
        settingCell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        settingCell.settingLabel.text = self.settingDetailArray[indexPath.row];
    }
    return settingCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    
    if (row == 1) {
        
        OpinionTableViewController *opinionViewController = [[OpinionTableViewController alloc]init];
        [self.navigationController pushViewController:opinionViewController animated:YES];
    }
}

#pragma mark 懒加载数据
- (NSArray *)settingDetailArray {
    if (!_settingDetailArray) {
        _settingDetailArray = [NSArray arrayWithObjects:@"关于我们",@"意见反馈",@"帮助",@"客服电话", nil];
    }
    return _settingDetailArray;
}


@end
