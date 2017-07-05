//
//  ChoosePhotoCell.m
//  多张图片选择器
//
//  Created by 苗建浩 on 2017/6/25.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ChoosePhotoCell.h"

@interface ChoosePhotoCell ()
@property (nonatomic, strong) UIImageView *chooseImage;


@end

@implementation ChoosePhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *chooseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        self.chooseImage = chooseImage;
        [self.contentView addSubview:chooseImage];
        
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 22, 0, 22, 22);
        deleBtn.backgroundColor = [UIColor clearColor];
        [deleBtn setBackgroundImage:[UIImage imageNamed:@"删除"] forState:0];
        [deleBtn addTarget:self action:@selector(deleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deleBtn = deleBtn;
        [self.contentView addSubview:deleBtn];
    }
    return self;
}

- (void)setChoosePhoto:(UIImage *)choosePhoto{
    _chooseImage.image = choosePhoto;
}

- (void)deleBtnClick:(UIButton *)sender{
    if (self.delePhotoBlock) {
        self.delePhotoBlock(@"");
    }
}

@end
