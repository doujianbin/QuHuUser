//
//  AppDelegate.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "AppDelegate.h"
#import "PeiZhenViewController.h"
#import "YuYueViewController.h"
#import "SignInViewController.h"
#import "MyTableViewController.h"
#import "BPush.h"
#import "LinkPageViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <Bugtags/Bugtags.h>

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()<UITabBarControllerDelegate,LinkPageViewControllerDelegate,WXApiDelegate>
@property (nonatomic,strong)LinkPageViewController *vc_linePage;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:1.2];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置navigationbar标题的字体和颜色
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#FA6262"], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#C7CAD1"], NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:18.0], NSFontAttributeName, nil]];
    if (![LoginStorage isFirstEnter]) {
        self.vc_linePage = [[LinkPageViewController alloc]initWithImageArray:@[@"linkPage_one",@"linkPage_two",@"linkPage_three",@"linkPage_four"]];
        self.vc_linePage.delegate = self;
        
        [self.window setRootViewController:_vc_linePage];
        
    }else{
        
        SignInViewController *signInView = [[SignInViewController alloc]init];
        UINavigationController *nav_signIn = [[UINavigationController alloc]initWithRootViewController:signInView];
        signInView.isSetRootView = YES;
        
        if ([LoginStorage isLogin] == NO) {
            [self.window setRootViewController:nav_signIn];
        }else{
            [self setTabBarRootView];
        }
    }
    
    
    /// 推送
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    //    {
    //        [nav.navigationBar setBarTintColor:UIColorFromRGB(0x39526d)];
    //        [_tabBarCtr.tabBar setBarTintColor:UIColorFromRGB(0x39526d)];
    //    }
    //    else
    //    {
    //        [nav.navigationBar setTintColor:UIColorFromRGB(0x39526d)];
    //        [_tabBarCtr.tabBar setTintColor:UIColorFromRGB(0x39526d)];
    //    }
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"iGYHDPZg6WBdG5HlovROutQG"pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */
    [WXApi registerApp:@"wxca05a9ac9c6686df" withDescription:@"小趣好护士"];
    
    [Bugtags startWithAppKey:@"889fb84e3179391c44711a9023d652c0" invocationEvent:BTGInvocationEventBubble];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setTabBarRootView{
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    tabBarVC.delegate = self;
    self.window.rootViewController = tabBarVC;
    
    PeiZhenViewController *peizhenVC = [[PeiZhenViewController alloc] init];
    UINavigationController *navpei = [[UINavigationController alloc]initWithRootViewController:peizhenVC];
    peizhenVC.tabBarItem.title = @"首页";
    peizhenVC.tabBarItem.image = [[UIImage imageNamed:@"Triangle 1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    peizhenVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Triangle s1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UINavigationController *peizhenNavibar = [[UINavigationController alloc] initWithRootViewController:peizhenVC];
    
    YuYueViewController *yuyueVC = [[YuYueViewController alloc] init];
    yuyueVC.tabBarItem.title = @"订单";
    yuyueVC.tabBarItem.image = [[UIImage imageNamed:@"orderDislect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    yuyueVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"orderSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *yuyueNavi = [[UINavigationController alloc] initWithRootViewController:yuyueVC];
    
    MyTableViewController * myVC = [[MyTableViewController alloc] init];
    myVC.tabBarItem.title = @"我的";
    myVC.tabBarItem.image = [[UIImage imageNamed:@"MyDislect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Myselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *myNavi = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    tabBarVC.viewControllers = @[navpei, yuyueNavi, myNavi];
}

- (void)enterMainViewController{
    [LoginStorage saveFirstEnterStatus:YES];
    [self.vc_linePage.view removeFromSuperview];
    
    SignInViewController *signInView = [[SignInViewController alloc]init];
    UINavigationController *nav_signIn = [[UINavigationController alloc]initWithRootViewController:signInView];
    signInView.isSetRootView = YES;
    
    if ([LoginStorage isLogin] == NO) {
        [self.window setRootViewController:nav_signIn];
    }else{
        [self setTabBarRootView];
    }
}


- (void)testLocalNotifi
{
    NSLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil];
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        
    }
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        //        if (result) {
        //            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
        //                if (result) {
        //                    NSLog(@"设置tag成功");
        //                }
        //            }];
        //        }
    }];
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        NSArray *arr_vcstack = [(UINavigationController *)viewController viewControllers];
        if ([arr_vcstack count]) {
            
        }
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinjieguo" object:self];
                
                break;
                
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinshibai" object:self];
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"source = %@", sourceApplication);
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        // 微信回调   发送消息通知  支付界面接收 查询订单是否支付成功
        return [WXApi handleOpenURL:url delegate:self];
       
    }
    return YES;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
