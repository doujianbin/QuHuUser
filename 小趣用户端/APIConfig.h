//
//  APIConfig.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h
//成功的状态吗
#define SUCCESS @"SUCCESS"
#define ERROR @"ERROR"
//验证stauts的状态
#define Status [responseDic objectForKey:@"status"]

// 开发环境
#define Development @"http://101.201.223.151:7001"

//发送验证码
#define MessageCode @"/quhu/accompany/public/messageCode"
//验证验证码
#define RegisterOrRefresh @"/quhu/accompany/public/registerOrRefresh"
//登录获取token
#define GetToken @"/oauth/token"
//获取首页显示信息（普通订单价格，特殊订单价格，banner图片，热门科室，热门医院）
#define GetShouYeMsg @"/quhu/accompany/user/getHomePageInfo?cityId=1"

//根据区域选择医院
#define AreaForHospital @"quhu/accompany/public/getAreaHospitalList?cityId=1"



#endif /* APIConfig_h */
