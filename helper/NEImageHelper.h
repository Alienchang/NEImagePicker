//  MediaCenter
//
//  Created by Alienchang on 2016/12/5.
//  Copyright © 2016年 Alienchang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PHAsset+Select.h"
#import "UIImage+Common.h"
#import "NEAlbum.h"
#define WINDOW_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface ImageModel : NSObject

@property (nonatomic, copy)   NSString *identifier; // 图片的标识

@property (nonatomic, strong) UIImage *thumbImage; // 图片

@property (nonatomic, strong) PHAsset * asset;   
@end



@interface NEImageHelper : NSObject

/**
 获取相册列表

 @param complete callback
 */
+ (void)getAlbumList:(void(^)(PHFetchResult <PHCollection *>*albumList))complete;

/**
 通过 asset  获取 imageData

 @param asset asset
 @param complete callback
 */
+ (void)getImageDataWithAsset:(PHAsset *)asset
                     complete:(void (^)(UIImage *image ,NSDictionary *info))complete;

/**
 获取指定大小的图片

 @param asset asset
 @param size size
 @param complete callback
 */
+ (void)getImageWithAsset:(PHAsset*)asset targetSize:(CGSize)size complete:(void (^)(UIImage *image))complete;

/**
 是否开启相册权限

 @return yes or no
 */
+ (BOOL)isOpenAuthority;

/**
 是否开启相机权限

 @return yes or no
 */
+ (BOOL)isCameraAuthority;

/**
 跳转到设置界面 
 */
+ (void)jumpToSetting;

/**
 获取相册列表
 @param includeEmpty 是否包含空相册
 */
+ (void)getAlbumList:(void (^)(NSArray<NEAlbum *> *albums))complete
        includeEmpty:(BOOL)includeEmpty;

+ (NEAlbum *)generateAlbumWithAssetCollection:(PHAssetCollection *)assetCollection;
@end
