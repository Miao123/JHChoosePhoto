//
//  ChoosePhoController.m
//  多张图片选择器
//
//  Created by 苗建浩 on 2017/6/21.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ChoosePhoController.h"
#import "ChoosePhotoCell.h"
#import "Header.h"

#define HeightClearance 2
#define WidthClearance 2

@interface ChoosePhoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) UICollectionView *photoColl;
@property (nonatomic, assign) float photoWidth;
@property (nonatomic, assign) float photoHeight;
@property (nonatomic, assign) int maxNumber;
@property (nonatomic, assign) int showNumber;
@property (nonatomic, strong) UIScrollView *imageScroll;
@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation ChoosePhoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.photoArr = [NSMutableArray array];
}


- (void)sendStrFunc:(CGSize)size maxNumber:(int)maxNumber showNumber:(int)showNumber{
    _photoWidth = size.width;
    _photoHeight = size.height;
    _maxNumber = maxNumber;
    _showNumber = showNumber;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *photoColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _photoWidth, _photoHeight) collectionViewLayout:layout];
    photoColl.delegate = self;
    photoColl.dataSource = self;
    photoColl.backgroundColor = [UIColor whiteColor];
    [photoColl registerClass:[ChoosePhotoCell class] forCellWithReuseIdentifier:@"cell"];
    self.photoColl = photoColl;
    [self.view addSubview:photoColl];
    
    
    
    
}

#pragma mark ------ UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArr.count == _maxNumber) {
        return _photoArr.count;
    }else{
        return _photoArr.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ChoosePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.row == _photoArr.count) {
        cell.choosePhoto = [UIImage imageNamed:@"添加图片"];
        cell.deleBtn.hidden = YES;
    }else{
        cell.deleBtn.hidden = NO;
        cell.choosePhoto = _photoArr[indexPath.row];
        [cell setDelePhotoBlock:^(NSString *str) {
            [_photoArr removeObjectAtIndex:(int)indexPath.row];
            [_photoColl reloadData];
            if (self.sendArrblock) {
                self.sendArrblock(_photoArr);
            }
        }];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_photoWidth / _showNumber - 1, _photoWidth / _showNumber - 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photoArr.count) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册选取", nil];
        [action showInView:self.view];
    }else{
        
        [self bigImage];
        
        NSUInteger tag = indexPath.row;
        self.imageScroll.contentOffset = CGPointMake(screenWidth * tag, 0);
        
        [UIView animateWithDuration:0.25 animations:^{
            _pageControl.hidden = NO;
            self.imageScroll.alpha = 1;
        }];
    }
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{
            //选择完成
        }];
    }else if (buttonIndex == 1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:^{
            //选择完成
        }];
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *formatInfo = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
    if ([formatInfo rangeOfString:@"JPG"].location == NSNotFound &&
        [formatInfo rangeOfString:@"PNG"].location == NSNotFound) {
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            [_photoArr addObject:originalImage];
            [_photoColl reloadData];
            if (self.sendArrblock) {
                self.sendArrblock(_photoArr);
            }
        }];
    }
}


- (void)bigImage{
    
    UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHight)];
    imageScroll.backgroundColor = [UIColor blackColor];
    imageScroll.pagingEnabled = YES;
    imageScroll.bounces = NO;
    imageScroll.delegate = self;
    imageScroll.contentSize = CGSizeMake(screenWidth * _photoArr.count, screenHight);
    imageScroll.alpha = 0;
    self.imageScroll = imageScroll;
    imageScroll.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_imageScroll];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake((screenWidth - 20) / 2, screenHight - 50, 20, 20);
    pageControl.currentPage = 0;
    pageControl.hidden = YES;
    pageControl.pageIndicatorTintColor = RGB_COLOR(70, 70, 70);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = _photoArr.count;
    self.pageControl = pageControl;
    [[UIApplication sharedApplication].keyWindow addSubview:_pageControl];
    
    
    UITapGestureRecognizer *scrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrTap:)];
    scrTap.numberOfTapsRequired = 1;
    scrTap.numberOfTouchesRequired = 1;
    [imageScroll addGestureRecognizer:scrTap];
    
    
    for (int i = 0; i < _photoArr.count; i++) {
        UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, screenHight)];
        bottonView.backgroundColor = [UIColor blackColor];
        [_imageScroll addSubview:bottonView];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHight)];
        imageView.image = _photoArr[i];
        imageView.userInteractionEnabled = YES;
        //        imageView.center = bottonView.center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bottonView addSubview:imageView];
    }
}

- (void)scrTap:(UITapGestureRecognizer *)tap{
    [_imageScroll removeFromSuperview];
    [_pageControl removeFromSuperview];
    self.imageScroll.alpha = 0;
    _pageControl.hidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    int number = offSetX / screenWidth;
    _pageControl.currentPage = number;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
