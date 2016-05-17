//
//  MycustomAnnotationView.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/9.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "MycustomAnnotationView.h"

@implementation MycustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.mybutton = [[UIButton alloc] initWithFrame:self.bounds];

        [self.mybutton setBackgroundColor:[UIColor blackColor]];
        
        [self addSubview:_mybutton];
    }
    return self;
}




@end
