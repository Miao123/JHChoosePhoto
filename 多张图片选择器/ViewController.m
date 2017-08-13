//
//  ViewController.m
//  多张图片选择器
//
//  Created by 苗建浩 on 2017/7/5.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ViewController.h"
#import "ChoosePhoController.h"
#import "Header.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"多张图片选择";
    self.view.backgroundColor = RGB_COLOR(240, 240, 240);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    ChoosePhoController *choosePhotoVC = [[ChoosePhoController alloc] init];
    choosePhotoVC.view.frame = CGRectMake(10, NAVGATION_ADD_STATUS_HEIGHT + 10, screenWidth - 20, 300 * DISTENCEH);
    [choosePhotoVC sendStrFunc:CGSizeMake(choosePhotoVC.view.frame.size.width, choosePhotoVC.view.frame.size.height) maxNumber:6 showNumber:4];
    [choosePhotoVC setSendArrblock:^(NSMutableArray *photoArr) {
        NSLog(@"photoArr = %@",photoArr);
//        UIImage *image = photoArr[0];
//        NSLog(@"image = %g    %g   %g",image.size.width * image.scale,image.size.height * image.scale,image.scale);
    }];
    [self addChildViewController:choosePhotoVC];
    [self.view addSubview:choosePhotoVC.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
