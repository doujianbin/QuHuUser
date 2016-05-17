//
//  NSString+Size.m
//  zlycare-iphone
//
//  Created by Ryan on 14-8-5.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)contentSize
{
    if (self && ![self isEqualToString:@""]) {
        return [self boundingRectWithSize:CGSizeMake(270, 90) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
        
    }else{
        return CGSizeZero;
    }
}

- (CGFloat)fittingLabelHeightWithWidth:(CGFloat)width andFontSize:(UIFont *)font
{
    if (self && ![self isEqualToString:@""]) {
        return [self boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height + 2;
    }else{
        return 0;
    }
}


- (CGFloat)fittingLabelWidthWithHeight:(CGFloat)height andFontSize:(UIFont *)font
{
    if (self && ![self isEqualToString:@""]) {
        return [self boundingRectWithSize:CGSizeMake(0, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width + 2;
    }else{
        return 0;
    }

}

- (CGSize)fittingLabelSizeWithBoundSize:(CGSize)size andFontSize:(UIFont *)font {
    if (self.length) {
        return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : font} context:nil].size;
    } else {
        return CGSizeZero;
    }
}

@end
