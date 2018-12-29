//
//  NEImagePickerController.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEAsset.h"
#import "NEImagePickerSourceConfig.h"

@class ALAssetsFilter;

FOUNDATION_EXTERN NSString * _Nullable kNEImagePickerStoredGroupKey;

typedef NS_ENUM(NSUInteger, NEImagePickerFilterType) {
    NEImagePickerFilterTypeNone,
    NEImagePickerFilterTypePhotos,
    NEImagePickerFilterTypeVideos,
};

@class NEImagePickerController;
@protocol NEImagePickerControllerDelegate <NSObject>
@optional
/**
 *  imagePickerController‘s seleted photos
 *
 *  @param imageAssets           the seleted photos packaged NEAsset type instances
 *  @param fullImage             if the value is yes, the seleted photos is full image
 */
- (void)neImagePickerController:(NEImagePickerController *_Nullable)imagePicker
                    imageAssets:(NSArray <NEAsset *>*_Nullable)imageAssets
                    isFullImage:(BOOL)fullImage;

- (void)neImagePickerController:(NEImagePickerController *_Nullable)imagePicker
                         images:(NSArray <UIImage *>*_Nullable)images
                    isFullImage:(BOOL)fullImage;

- (void)neImagePickerControllerDidCancel:(NEImagePickerController *_Nullable)imagePicker;

- (void)neImagePickerControllerDidSelected:(NEImagePickerController *_Nullable)imagePicker;
@end


@interface NEImagePickerController : UINavigationController
@property (nonatomic, weak)   id<NEImagePickerControllerDelegate> _Nullable imagePickerDelegate;
@property (nonatomic, assign) NEImagePickerFilterType filterType;
@property (nonatomic ,assign) NSUInteger limiteCount;
@property (nonatomic ,copy)   NSString * _Nullable confirmText;   ///底部toolBar 确认按钮文案
@property (nonatomic ,strong) UIColor * _Nullable  tintColor;
@property (nonatomic ,strong) UIColor * _Nullable  disableTintColor;
@property (nonatomic ,strong) UIColor * _Nullable  disableTitleColor;
@property (nonatomic ,strong) UIColor * _Nullable  enableTitleColor;

@property (nonatomic ,strong) NEImagePickerSourceConfig *sourceConfig;

///获取系统相册最后一张照片
- (void)lastAsset:(void (^_Nullable)(NEAsset * _Nullable, NSError *_Nullable))block;
@end
