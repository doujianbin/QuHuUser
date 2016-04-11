//
//  PictureCollectionViewCell.m
//  小趣用户端
//
//  Created by lixiao on 16/3/16.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iv_photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, frame.size.width - 10, frame.size.height - 10)];
//        self.iv_photo.contentMode = UIViewContentModeScaleAspectFit;
        self.iv_photo.userInteractionEnabled = YES;
        [self addSubview:self.iv_photo];
        
        self.iv_delete = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 20, 0, 20, 20)];
        [self.iv_delete setImage:[UIImage imageNamed:@"1.5编辑档案－填写信息_03"]];
        [self.iv_delete setUserInteractionEnabled:YES];
        [self.iv_delete setHidden:YES];
        [self addSubview:self.iv_delete];

    }
    return self;
}

@end
