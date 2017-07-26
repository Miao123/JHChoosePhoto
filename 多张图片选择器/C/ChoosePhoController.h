//
//  ChoosePhoController.h
//  多张图片选择器
//
//  Created by 苗建浩 on 2017/6/21.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePhoController : UIViewController
@property (nonatomic, copy) NSString *sendStr;
@property (nonatomic, copy) void(^sendArrblock)(NSMutableArray *);

/*
 maxNumber     上传的最大数量
 showNumber    每行显示的最多数量
 */
- (void)sendStrFunc:(CGSize)size maxNumber:(int)maxNumber showNumber:(int)showNumber;


@end
