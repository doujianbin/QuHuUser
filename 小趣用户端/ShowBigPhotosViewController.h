//
//  ShowCertificateBigPhotosViewController.h
//  zlycare-iphone
//
//  Created by lixiao on 14-10-13.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"

@interface ShowBigPhotosViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView       *sv_showBigPhoto;//底层scrollView
@property (nonatomic,strong) MRZoomScrollView   *zoomScrollView_showPhoto;
@property (nonatomic,strong) NSMutableArray     *arr_images;//图片数组uuid
@property (nonatomic,assign) int                 int_index;//第几个cell
@end
