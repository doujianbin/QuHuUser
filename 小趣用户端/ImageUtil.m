//
//  ImageUtil.m
//  ZLYDoc
//
//  Created by apple on 14-4-28.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "ImageUtil.h"

#define MAX_IMAGEPIX 500

@implementation ImageUtil

+(UIImage *)imageWithCompressImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if(width <= MAX_IMAGEPIX && height <= MAX_IMAGEPIX){
        return image;//不需要压缩
    }
    
    if(width == 0 || height == 0){
        return image;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX /
    width;
    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat compressFactor = 0.0;
    
    if(widthFactor > heightFactor){
        compressFactor = heightFactor;//compress to fit height
    }else{
        compressFactor = widthFactor;//compress to fit width
    }
    
//    CGFloat compressedWidth = width * compressFactor;
//    CGFloat compressedHeight = height * compressFactor;
    NSInteger compressedWidth = width * compressFactor;
    NSInteger compressedHeight = height * compressFactor;
    CGSize targetSize = CGSizeMake(compressedWidth,compressedHeight);
    
    UIGraphicsBeginImageContext(targetSize);//this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = compressedWidth;
    thumbnailRect.size.height = compressedHeight;
    
    [image drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();//pop the context to get back to the default
    
    if(newImage != nil){
        return newImage;
    }else{
        return image;
    }
}

+(UIImage *)imageWithScaleImage:(UIImage *)image forSize:(CGSize)targetSize
{
    CGSize imageSize = image.size;
    
    if(CGSizeEqualToSize(imageSize,targetSize) == YES){
        return image;
    }
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleWidth = targetSize.width;
    CGFloat scaleHeight = targetSize.height;
    
    if(width <= scaleWidth && height <= scaleHeight){
        return image;
    }
    
    if(width == 0 || height == 0){
        return image;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = scaleWidth / width;
    CGFloat heightFactor = scaleHeight / height;
    CGFloat scaleFactor = 0.0;
    
    if(widthFactor > heightFactor){
        scaleFactor = heightFactor;//scale to fit height
    }else{
        scaleFactor = widthFactor;//scale to fit width
    }
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize target = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(target);//this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();//pop the context to get back to the default
    
    if(newImage != nil){
        return newImage;
    }else{
        return image;
    }
}
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

//传入UIColor得到纯色UIImage
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    //添加容错
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0,0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
