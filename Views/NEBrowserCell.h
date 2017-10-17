//
//  NEBrowserCell.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class NEPhotoBrowser;

@interface NEBrowserCell : UICollectionViewCell

@property (nonatomic, weak) NEPhotoBrowser *photoBrowser;

@property (nonatomic, strong) ALAsset *asset;

@end
