//
//  NSArray+Extension.m
//  小趣用户端
//
//  Created by 刘伟 on 16/1/30.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }else {
        return self[index];
    }
}

@end

@implementation NSMutableDictionary (Extension)

- (void)safeSetObject:(id)object ForKey:(id)key {
    if (object) {
        [self setObject:object forKey:key];
    }
    return;
}

@end