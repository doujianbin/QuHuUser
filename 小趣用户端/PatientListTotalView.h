//
//  PatientListTotalView.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientListTotalView : UIView

@property (nonatomic ,strong)UIImageView *img_detail;
@property (nonatomic ,strong)UILabel *lb_detail;
@property (nonatomic ,strong)UIView  *v_line;

-(void)setLabelText:(NSString *)str withOrifinY:(CGFloat)originY;
@end
