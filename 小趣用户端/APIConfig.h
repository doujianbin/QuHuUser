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
#define Message [responseDic objectForKey:@"message"]
//验证stauts的状态
#define Status [responseDic objectForKey:@"status"]
#define Message [responseDic objectForKey:@"message"]
// 开发环境
#define Development @"https://ci.haohushi.me:7009"
//正式环境 http://app.haohushi.me:8080    https://app.haohushi.me:8443
//开发环境 http://101.201.223.151:7001
//测试环境 https://ci.haohushi.me:7009
//发送验证码
#define MessageCode @"/quhu/accompany/public/U/messageCode"
//验证验证码
#define RegisterOrRefresh @"/quhu/accompany/public/registerOrRefresh"
//登录获取token
#define GetToken @"/oauth/token"
//获取用户基本信息
#define GetUserInfo @"/quhu/accompany/public/getUserInfo"

//获取首页显示信息（普通订单价格，特殊订单价格，banner图片，热门科室，热门医院）
#define GetShouYeMsg @"/quhu/accompany/public/getHomePageInfo?cityId=110100"

//根据区域选择医院
#define AreaForHospital @"/quhu/accompany/public/getAreaHospitalList?cityId=110100"
// 查询用户下所有家庭成员
#define GetFamilyList @"/quhu/accompany/user/getFamilyList"
// 添加成员
#define CreateFamily @"/quhu/accompany/user/createFamily"
// 删除成员
#define DeleteFamily @"/quhu/accompany/user/deleteUserFamilyMemberById"
// 修改成员
#define UpdateFamily @"/quhu/accompany/user/updateFamily"
// 查询  科室 医生
#define GetDeptGroupDoctor @"/quhu/accompany/public/getDeptGroupDoctorList?cityId=110100"
//用户查询医生加号信息
#define UserSelectDoctorMsg @"/quhu/accompany/public/getAppointListAll"
//用户创建普通陪诊
#define CreateCommonOrder @"/quhu/accompany/user/order/createCommonOrder"
//用户创建特需订单
#define CreateSpecialOrder @"/quhu/accompany/user/order/createSpecialOrder"
// 用户查询未结束的订单详情
#define QueryUnfinishedList @"/quhu/accompany/user/order/queryUnfinishedList"
// 用户查询历史订单
#define QueryHistoryList @"/quhu/accompany/user/order/queryHistoryList"
//用户查询全部订单列表
#define GetOrderList @"/quhu/accompany/user/order/getOrderList"
// 微信支付 创建预付订单
#define CreateWeiXinPay @"/quhu/accompany/user/pay/unifiedorder"
// 微信支付回调查询
#define SelectWXPay @"/quhu/accompany/user/pay/orderquery"
// 上传channelID
#define SaveChannelId @"/quhu/accompany/user/saveChannelId"
// 版本升级
#define VersionInfo @"/quhu/accompany/common/versionInfo"
// 获取就诊人列表
#define GetPatientListByPage @"/quhu/accompany/user/getAllPatientsList"
// 获取就诊人档案列表
#define GetPatientRecordsByPage @"/quhu/accompany/user/getPatientRecordsByPage"
// 更新就诊人档案
#define UpdatePatientRecords @"/quhu/accompany/user/updatePatientRecords"
// 获取可选陪诊时间列表
#define GetSelectiveAccompanyTimeSchedule @"/quhu/accompany/public/getSelectiveAccompanyTimeSchedule"
// 用户评价
#define RemarkOrder @"/quhu/accompany/user/userRemark/remarkOrder"
// 更新取消原因
#define UpdateCancelreason @"/quhu/accompany/user/updateCancelreason"
// 从订单列表删除订单
#define DeleteOrder @"/quhu/accompany/user/order/deleteOrder"
// 是否在孕期
#define UpdatePregnancyStatus @"/quhu/accompany/user/updatePregnancyStatus"
// 已登陆的时候 根据经纬度  拿数据
#define GetNearByHospitalList @"/quhu/accompany/user/getNearByHospitalList"
// 未登录 根据经纬度 拿数据
#define GetNearPublicByHospitalList @"/quhu/accompany/public/getNearByHospitalList"
// 根据医院名称或别名查询医院列表
#define QueryHospital @"/quhu/accompany/public/queryHospital"
//获取用户全部优惠券
#define QueryUserCouponsAll @"/quhu/accompany/user/coupon/queryUserCouponsAll"
//用户端 1.2 新增接口 获取用户优惠券 限制 地区和套餐类型(获取部分优惠券(未过期的))
#define QueryUserCouponsByAreaIdAndOrderType @"/quhu/accompany/user/coupon/queryUserCouponsByAreaIdAndOrderType"
//根据百度地图返回经纬度获取首页信息
#define GetHomePageInfoWithCity @"/quhu/accompany/user/getHomePageInfoWithCity"
//获取开屏广告
#define GetOneOpenAd @"/quhu/accompany/public/getOneOpenAd"



#endif /* APIConfig_h */
