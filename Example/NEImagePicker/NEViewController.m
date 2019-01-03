//
//  NEViewController.m
//  NEImagePicker
//
//  Created by 1217493217@qq.com on 06/13/2018.
//  Copyright (c) 2018 1217493217@qq.com. All rights reserved.
//

#import "NEViewController.h"
#import <NEImagePicker/NEAlbumTableViewController.h>
#import <NEImagePicker/NEAlbum.h>
#import <NEImagePicker/NEImagePickerController.h>
#import <NEImagePicker/NEImageHelper.h>
@interface NEViewController ()<NEImagePickerControllerDelegate>

@end

@implementation NEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NEImageHelper lastVideoCover:^(UIImage *cover) {
        
    }];
    NEImagePickerController *navigationController = [NEImagePickerController new];
    [navigationController setOpen3DTouch:YES];
    NEImagePickerSourceConfig *sourceConfig = [NEImagePickerSourceConfig new];
    [sourceConfig setImageunselectedIcon:[UIImage imageNamed:@"chatIcChoseN"]];
    [sourceConfig setImageSelectedIcon:[UIImage imageNamed:@"chatIcChoseS"]];
    [sourceConfig setNavigationBackImage:[UIImage imageNamed:@"ic_chat_back"]];
    [navigationController setSourceConfig:sourceConfig];
    [navigationController setTintColor:[UIColor colorWithRed:202 / 255. green:228 / 255. blue:94 / 255. alpha:1]];
    [navigationController setDisableTintColor:[UIColor colorWithRed:244 /255. green:244 /255. blue:244 /255. alpha:1]];
    [navigationController setDisableTitleColor:[UIColor colorWithRed:180 / 255. green:182 / 255. blue:184 / 255. alpha:1]];
    [navigationController setEnableTitleColor:[UIColor whiteColor]];
    [navigationController setConfirmText:@"Done"];
    [navigationController setImagePickerDelegate:self];
    [navigationController setLimiteCount:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController animated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- NEImagePickerControllerDelegate
- (void)neImagePickerController:(NEImagePickerController *_Nullable)imagePicker
                    imageAssets:(NSArray <NEAsset *>*_Nullable)imageAssets
                    isFullImage:(BOOL)fullImage {
    
}

- (void)neImagePickerController:(NEImagePickerController *_Nullable)imagePicker
                         images:(NSArray <UIImage *>*_Nullable)images
                    isFullImage:(BOOL)fullImage {
    
}

- (void)neImagePickerControllerDidCancel:(NEImagePickerController *_Nullable)imagePicker {
    
}

- (void)neImagePickerControllerDidSelected:(NEImagePickerController *_Nullable)imagePicker {
    
}

@end
