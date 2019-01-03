//  MediaCenter
//
//  Created by Alienchang on 2016/12/5.
//  Copyright © 2016年 Alienchang. All rights reserved.
//
#import "NEImageHelper.h"

@implementation NEImageHelper

+ (NEAlbum *)generateAlbumWithAssetCollection:(PHAssetCollection *)assetCollection {
    NEAlbum *album = [NEAlbum new];
    [album setLocalIdentifier:assetCollection.localIdentifier];
    [album setImagesCout:assetCollection.estimatedAssetCount];
    return album;
}

+ (void)getAlbumList:(void (^)(NSArray<NEAlbum *> *albums))complete
        includeEmpty:(BOOL)includeEmpty {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_queue_t fetchImageQueue = dispatch_queue_create("com.sc.fetchAlbums", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        dispatch_async(fetchImageQueue, ^{
            [NEImageHelper getAlbumList:^(PHFetchResult<PHCollection *> *albumList) {
                NSInteger emptyCollectionNum = 0;
                for (NSInteger i = 0; i < albumList.count; ++ i) {
                    PHAssetCollection *assetCollection = (PHAssetCollection *)albumList[i];
                    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                    if (!fetchResult.count) {
                        emptyCollectionNum ++;
                    }
                }
                NSMutableArray *albums = [NSMutableArray new];
                __block BOOL hadAlbumRecentlyRemoved = NO;  // 要删除『AlbumRecentlyRemoved』的相册

                for (NSInteger i = 0; i < albumList.count; ++ i) {
                    PHAssetCollection *assetCollection = (PHAssetCollection *)albumList[i];
                    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                    NEAlbum *album = [NEAlbum new];
                    [album setLocalIdentifier:assetCollection.localIdentifier];
                    PHAsset *asset = nil;
                    if (fetchResult.count || includeEmpty) {
                        asset = fetchResult[0];
                        [album setImagesCout:fetchResult.count];
                        [NEImageHelper getImageWithAsset:asset targetSize:CGSizeMake(64 * 2, 64 * 2) complete:^(UIImage *image) {
                            [album setAlbumImage:image];
                            [album setAlbumTitle:assetCollection.localizedTitle];
                            // PHAssetCollectionSubtypeAlbumCloudShared   icloud
                            // 要删除『AlbumRecentlyRemoved』的相册，RecentlyRemoved的subType是1000000201
                            if (assetCollection.assetCollectionSubtype == 1000000201) {
                                hadAlbumRecentlyRemoved = YES;
                            }else{
                                [albums insertObject:album atIndex:0];
                            }
                            
                            if (albums.count == albumList.count  - (includeEmpty?0:emptyCollectionNum) - (hadAlbumRecentlyRemoved?1:0)) {
                                if (complete) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        complete(albums);
                                    });
                                }
                            }
                        }];
                    }
                }
            }];
        });
    }];
}

+ (void)getAlbumList:(void(^)(PHFetchResult <PHCollection *>*albumList))complete {
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    complete?complete(result):nil;
}

+ (void)getImageDataWithAsset:(PHAsset *)asset
                     complete:(void (^)(UIImage *image ,NSDictionary *info))complete
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        complete?complete(image ,info):nil;
    }];
}

+ (void)getImageWithAsset:(PHAsset*)asset
               targetSize:(CGSize)size
                 complete:(void (^)(UIImage *image))complete {
    PHImageManager *imageManager = [PHImageManager defaultManager];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setSynchronous:YES];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    if ([NSThread isMainThread]) {
        [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if ([[info valueForKey:PHImageResultIsDegradedKey] integerValue] == 0){
                complete?complete(result):nil;
            }
        }];
    } else {
        ///不在主线程调用可能不回调
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if ([[info valueForKey:PHImageResultIsDegradedKey] integerValue] == 0){
                    complete?complete(result):nil;
                }
            }];
        });
        
    }
}

+ (BOOL)isOpenAuthority {
    return [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied;
}

+ (BOOL)isCameraAuthority {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)jumpToSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (NEAsset *)lastVideoAsset {
    return nil;
}
+ (void)lastVideoCover:(void(^)(UIImage *cover))complete {
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *lasetAsset = assetsFetchResults.firstObject;
    if (lasetAsset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:lasetAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                UIImage *cover = [self imageOfVideoAsset:urlAsset];
                if (complete) {
                    complete(cover);
                }
            }];
        }
}

+ (UIImage *)imageOfVideoAsset:(AVAsset *)videoAsset {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    NSError *error = nil;
    CMTime actucalTime = CMTimeMake(1, 1);
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:actucalTime actualTime:&actucalTime error:&error];
    if (error) { NSLog(@"截取视频图片失败:%@", error.localizedDescription); return nil;}
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

@end

@implementation ImageModel



@end


