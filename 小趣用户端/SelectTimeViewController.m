//
//  SelectTimeViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SelectTimeViewController.h"
#import "TXOrderViewController.h"
@interface SelectTimeViewController ()

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"医生名字";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnAction{
    TXOrderViewController *txorderView = [[TXOrderViewController alloc]init];
    [self.navigationController pushViewController:txorderView animated:YES];
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
