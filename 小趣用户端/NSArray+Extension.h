//
//  NSArray+Extension.h
//  小趣用户端
//
//  Created by 刘伟 on 16/1/30.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableDictionary (Extension)

- (void)safeSetObject:(id)object ForKey:(id)key;

@end
