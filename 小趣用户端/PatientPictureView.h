//
//  PatientPictureView.h
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatientPictureViewDelegate <NSObject>

- (void)deletePictureWithIndex:(int)index;
- (void)didSelectedWithIndex:(int)index withSection:(int)section;
- (void)addPicture;

@end

@interface PatientPictureView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)NSMutableArray     *arr_picture;
@property (nonatomic,strong)UICollectionView   *collectionView;
@property (nonatomic,strong)NSData             *data_addImg;
@property (nonatomic,strong)UIView             *v_line;
@property (nonatomic)BOOL     isEdit;
@property (nonatomic,assign)id<PatientPictureViewDelegate>delegate;

- (void)loadCollectionViewWithPicturesArray:(NSArray *)arr_picture withOrifinY:(CGFloat)originY;

@end
