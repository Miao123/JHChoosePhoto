//
//  ChoosePhotoCell.h
//  多张图片选择器
//
//  Created by 苗建浩 on 2017/6/25.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePhotoCell : UICollectionViewCell
@property (nonatomic, copy) void (^delePhotoBlock)(NSString *);

@property (nonatomic, strong) UIImage *choosePhoto;
@property (nonatomic, strong) UIButton *deleBtn;

@end
