//
//  NEAssetsViewCell.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import "UIImage+NEImagePicker.h"
#import "NEAsset.h"
@class NEAssetsViewCell;

@protocol NEAssetsViewCellDelegate <NSObject>
@optional

- (void)didSelectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell;
- (void)didDeselectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell;
@end

@interface NEAssetsViewCell : UICollectionViewCell

@property (nonatomic, strong) NEAsset *asset;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<NEAssetsViewCellDelegate> delegate;

@property (nonatomic ,strong) UIImage *selectedImageIcon;
@property (nonatomic ,strong) UIImage *unselectedImageIcon;

- (void)fillWithAsset:(NEAsset *)asset isSelected:(BOOL)seleted;

@end
