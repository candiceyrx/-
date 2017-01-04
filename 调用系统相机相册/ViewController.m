//
//  ViewController.m
//  调用系统相机相册
//
//  Created by Candice on 16/12/22.
//  Copyright © 2016年 刘灵. All rights reserved.
//

#import "ViewController.h"
#import "NSDataAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) NSString *imageFileName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-200)/2, 10, 100, 100)];
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    _headView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_headView];
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = 100.0f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((self.view.bounds.size.width-100)/2, self.headView.frame.origin.y+self.headView.frame.size.height+10, 100, 60);
    [button setTitle:@"设置头像" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender {
    UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertSelect addAction:camera];
    [alertSelect addAction:photo];
    [alertSelect addAction:cancelAction];
    
    [self presentViewController:alertSelect animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSLog(@"\n%@",info);
    UIImage *image = nil;
    if ([picker allowsEditing]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *result = [imageData base64Encoding];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        __block NSString *fileName;
        NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *myAsset) {
            ALAssetRepresentation *representation = [myAsset defaultRepresentation];
            fileName = [representation filename];
            NSLog(@"======截取后的图片名:%@",fileName);
        };
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
        [assetsLibrary assetForURL:imageURL resultBlock:resultBlock failureBlock:nil];
    } else {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        NSString *imageFileName = @"uploadImage";
    }
    self.headView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    if (!error) {
        NSLog(@"图片保存成功");
    } else {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
