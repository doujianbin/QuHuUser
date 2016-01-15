//
//  AFNManager.h
//  Halo+
//
//  Created by 窦建斌 on 15/12/30.
//  Copyright © 2015年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNManager : NSObject

@property (nonatomic, retain)AFHTTPRequestOperationManager *manager;

+ (AFNManager *)shareManager;

- (void)RequestJsonWithUrl:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter result:(void (^)(id responseDic))success fail:(void (^)(NSError *error))fail;

- (void)POSTRequestKeyValueData:(NSString *)url parameter:(NSString *)parameter result:(void (^)(id resposeDic))success fail:(void (^)(NSError *error))fail;


@end
