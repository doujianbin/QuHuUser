//
//  EditPatientViewController.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/16.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientDetailEntity.h"

@protocol EditPatientViewControllerDelegate <NSObject>

- (void)refreshDataWithPatientDetailEntity:(PatientDetailEntity *)entity;

@end

@interface EditPatientViewController : UIViewController

@property (nonatomic ,strong)PatientDetailEntity *entity;
@property (nonatomic ,assign)id<EditPatientViewControllerDelegate>delegate;

@end
