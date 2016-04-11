//
//  PatientPictureView.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/15.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PatientPictureView.h"
#import "PictureCollectionViewCell.h"

#define HEIGHT (SCREEN_WIDTH - 30 - 10)/3

@implementation PatientPictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:CGSizeMake(((CGFloat)SCREEN_WIDTH - 23 - 10)/3, (SCREEN_WIDTH - 30 - 10)/3)];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 8);//设置其边界
        //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
        [self addSubview:_collectionView];
        
        self.v_line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, SCREEN_WIDTH, 0.5)];
        [self.v_line setBackgroundColor:[UIColor colorWithHexString:@"dbdcdd"]];
        [self addSubview:self.v_line];
        
        UIImage *img_add = [UIImage imageNamed:@"upphoto"];
        self.data_addImg = UIImagePNGRepresentation(img_add);
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr_picture.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell"forIndexPath:indexPath];
    id imgData = [self.arr_picture objectAtIndex:indexPath.row];
    if (self.isEdit) {
        if (indexPath.row == self.arr_picture.count - 1 && [imgData isKindOfClass:[UIImage class]]) {
            if ([self.data_addImg isEqualToData:UIImagePNGRepresentation(imgData)]) {
                [cell.iv_delete setHidden:YES];
            }else{
                [cell.iv_delete setHidden:NO];
            }
        }else{
            [cell.iv_delete setHidden:NO];
        }
    }
    if ([imgData isKindOfClass:[UIImage class]]) {
        [cell.iv_photo setImage:imgData];
    }else if ([imgData isKindOfClass:[NSString class]]){
        [cell.iv_photo sd_setImageWithURL:imgData placeholderImage:nil];
    }
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
    [cell.iv_delete addGestureRecognizer:singleTap1];
    cell.iv_delete.tag = indexPath.row;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction:)];
    [cell.iv_photo addGestureRecognizer:singleTap2];
    cell.iv_photo.tag = indexPath.row;
    return cell;
}

- (void)deleteAction:(UITapGestureRecognizer *)recognizer{
    UIImageView *iv_sender = (UIImageView *)[recognizer view];
    [self.delegate deletePictureWithIndex:(int)iv_sender.tag];
}

- (void)selectAction:(UITapGestureRecognizer *)recognizer{
    UIImageView *iv_sender = (UIImageView *)[recognizer view];
    id imgData = [self.arr_picture objectAtIndex:iv_sender.tag];

    if (self.isEdit) {
        if (iv_sender.tag == self.arr_picture.count - 1 && [imgData isKindOfClass:[UIImage class]]) {
            if ([self.data_addImg isEqualToData:UIImagePNGRepresentation(imgData)]) {
                [self.delegate addPicture];
            }
        }
    }else{
        [self.delegate didSelectedWithIndex:(int)iv_sender.tag withSection:(int)self.collectionView.tag];
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
    
}
- (void)loadCollectionViewWithPicturesArray:(NSArray *)arr_picture withOrifinY:(CGFloat)originY
{
    self.arr_picture = [NSMutableArray arrayWithArray:arr_picture];
    if (self.isEdit) {
        if (self.arr_picture.count < 9) {
            [self.arr_picture addObject:[UIImage imageNamed:@"upphoto"]];
        }
    }
    [self.collectionView reloadData];
    if (self.arr_picture.count > 0) {
        if (self.arr_picture.count%3 > 0) {
            [self.collectionView setFrame:CGRectMake(0, 5, SCREEN_WIDTH,(self.arr_picture.count/3 + 1)*HEIGHT + self.arr_picture.count/3 * 5)];
            [self setFrame:CGRectMake(0, originY,SCREEN_WIDTH,CGRectGetMaxY(self.collectionView.frame) + 15 + 0.5)];
        }else{
            [self.collectionView setFrame:CGRectMake(0, 5, SCREEN_WIDTH,self.arr_picture.count/3*HEIGHT + (self.arr_picture.count/3 - 1) * 5)];
            [self setFrame:CGRectMake(0, originY, SCREEN_WIDTH,CGRectGetMaxY(self.collectionView.frame) + 15 + 0.5)];
        }
    }else{
         [self setFrame:CGRectMake(0,originY, SCREEN_WIDTH,0)];
    }
    [self.v_line setFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 15, SCREEN_WIDTH, 0.5)];
}

@end
