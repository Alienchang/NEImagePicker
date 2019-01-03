//
//  NEPhotoBrowserViewController.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NESendButton.h"
#import "NEAsset.h"
@class NEImageFlowViewController;
@class NEPhotoBrowser;
@protocol NEPhotoBrowserDelegate <NSObject>
@optional
- (void)ne_sendImagesFromPhotobrowser:(NEPhotoBrowser *)photoBrowse currentAsset:(NEAsset *)asset;
- (NSUInteger)ne_seletedPhotosNumberInPhotoBrowser:(NEPhotoBrowser *)photoBrowser;
- (BOOL)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(NEAsset *)asset;
- (BOOL)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser seletedAsset:(NEAsset *)asset;
- (void)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser deseletedAsset:(NEAsset *)asset;
- (void)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage;
@end

@interface NEPhotoBrowser : UIViewController

@property (nonatomic, weak) id<NEPhotoBrowserDelegate> delegate;
@property (nonatomic, strong) NESendButton *sendButton;
@property (nonatomic ,strong) UIColor *tintColor;
@property (nonatomic ,strong) UIColor *disableTintColor;

- (instancetype)initWithPhotos:(NSArray *)photosArray
                  currentIndex:(NSInteger)index
                     fullImage:(BOOL)isFullImage;


- (instancetype)initWithAssets:(NSArray <NEAsset *>*)assets
                  currentIndex:(NSInteger)index
                     fullImage:(BOOL)isFullImage;

- (void)hideControls;
- (void)toggleControls;
@end
