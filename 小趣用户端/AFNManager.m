//
//  AFNManager.m
//  Halo+
//
//  Created by 洋赵 on 15/12/30.
//  Copyright © 2015年 洋赵. All rights reserved.
//

#import "AFNManager.h"

@implementation AFNManager

+ (AFNManager *)shareManager
{
    static AFNManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        manager = [[AFNManager alloc] init];
        
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [_manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",  @"text/json", @"text/html", @"text/javascript",nil]];
        
        
    }
    return self;
}

- (void)RequestJsonWithUrl:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter result:(void (^)(id responseDic))success fail:(void (^)(NSError *error))fail
{
    if ([method isEqualToString:@"GET"]) {
        [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (success) {
                success(responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            fail(error);
        }];
    }else if ([method isEqualToString:@"POST"]) {
        [self.manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            fail(error);
        }];
    }
}

- (void)POSTRequestKeyValueData:(NSString *)url parameter:(NSString *)parameter result:(void (^)(id resposeDic))success fail:(void (^)(NSError *error))fail
{
    NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:data];
    
    NSOperation *operation =
    [_manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         // 成功后的处理
                                         if (success) {
                                             success(responseObject);
                                         }
                                         
                                         
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         // 失败后的处理
                                         fail(error);
                                     }];
    [_manager.operationQueue addOperation:operation];
    

    
    
}


@end
