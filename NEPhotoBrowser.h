//
//  NEPhotoBrowserViewController.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NESendButton.h"
@class NEImageFlowViewController;
@class NEPhotoBrowser;
@protocol NEPhotoBrowserDelegate <NSObject>

@required
- (void)sendImagesFromPhotobrowser:(NEPhotoBrowser *)photoBrowse currentAsset:(ALAsset *)asset;
- (NSUInteger)seletedPhotosNumberInPhotoBrowser:(NEPhotoBrowser *)photoBrowser;
- (BOOL)photoBrowser:(NEPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(ALAsset *)asset;
- (BOOL)photoBrowser:(NEPhotoBrowser *)photoBrowser seletedAsset:(ALAsset *)asset;
- (void)photoBrowser:(NEPhotoBrowser *)photoBrowser deseletedAsset:(ALAsset *)asset;
- (void)photoBrowser:(NEPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage;
@end

@interface NEPhotoBrowser : UIViewController

@property (nonatomic, weak) id<NEPhotoBrowserDelegate> delegate;
@property (nonatomic, strong) NESendButton *sendButton;

- (instancetype)initWithPhotos:(NSArray *)photosArray
                  currentIndex:(NSInteger)index
                     fullImage:(BOOL)isFullImage;

- (void)hideControls;
- (void)toggleControls;
@end
