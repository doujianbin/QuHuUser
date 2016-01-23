//
//  AppointEntity.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/19.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointEntity : NSObject

@property (nonatomic,strong)NSString   *_id;
@property (nonatomic,strong)NSString   *startTime;
@property (nonatomic,strong)NSString   *status;

+ (NSArray *)parseAppointListWithJson:(id)json;

@end
