//
//  ImageUtil.h
//  ZLYDoc
//
//  Created by apple on 14-4-28.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

+(UIImage *)imageWithCompressImage:(UIImage *)image;//有判断条件，到了多大之后再压缩

+(UIImage *)imageWithScaleImage:(UIImage *)image forSize:(CGSize)targetSize;//图片压缩到指定大小
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;//图片的截取

+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;//传入UIColor得到纯色UIImage

+(UIImage *)fixOrientation:(UIImage *)aImage;

+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height;
@end
