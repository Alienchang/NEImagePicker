//
//  NEAlbum.m
//  NESocialClient
//
//  Created by Chang Liu on 11/21/17.
//  Copyright © 2017 Next Entertainment. All rights reserved.
//

#import "NEAlbum.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "NEImageHelper.h"
@interface NEAlbum()
@property (nonatomic ,strong) dispatch_queue_t fetchImageQueue;
@end
@implementation NEAlbum
- (void)fetchAlbumImage:(void(^)(UIImage *image))complete {
    PHFetchOptions *fetchOption = [PHFetchOptions new];
    [fetchOption setIncludeAssetSourceTypes:PHAssetSourceTypeUserLibrary];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:fetchOption];
    if (result.count) {
        PHAssetCollection *assetCollection = result[0];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        PHAsset *asset = fetchResult[0];
        __weak typeof(self) weakself = self;
        [NEImageHelper getImageWithAsset:asset targetSize:CGSizeMake(200, 200) complete:^(UIImage *image) {
            [weakself setAlbumImage:image];
            if (complete) {
                complete(image);
            }
        }];
    } else {
        complete(nil);
    }
    
}


- (void)fetchAssetsWithoutImage:(void (^)(NSArray<NEAsset *> *assets))complete {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (!self.fetchImageQueue) {
            self.fetchImageQueue = dispatch_queue_create("com.sc.fetchImage", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        }
        dispatch_async(self.fetchImageQueue, ^{
            PHFetchOptions *fetchOption = [PHFetchOptions new];
            [fetchOption setIncludeAssetSourceTypes:PHAssetSourceTypeUserLibrary];
            PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:fetchOption];
            if (result.count) {
                PHAssetCollection *assetCollection = result[0];
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                NSMutableArray *assets = [NSMutableArray new];
                for (PHAsset *asset in fetchResult) {
                    NEAsset *neasset = [NEAsset new];
                    [neasset setPhAsset:asset];
                    [neasset setLocalIdentifier:asset.localIdentifier];
                    [assets addObject:neasset];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(assets);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(nil);
                    }
                });
            }
        });
    }];
}
- (void)fetchAssets:(void(^)(NSArray <NEAsset *>* assets))complete {
    if (!self.fetchImageQueue) {
        self.fetchImageQueue = dispatch_queue_create("com.sc.fetchImage", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    dispatch_async(self.fetchImageQueue, ^{
        PHFetchOptions *fetchOption = [PHFetchOptions new];
        [fetchOption setIncludeAssetSourceTypes:PHAssetSourceTypeUserLibrary];
        PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:fetchOption];
        if (result.count) {
            PHAssetCollection *assetCollection = result[0];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSMutableArray *assets = [NSMutableArray new];
            for (PHAsset *asset in fetchResult) {
                NEAsset *neasset = [NEAsset new];
                [NEImageHelper getImageWithAsset:asset targetSize:CGSizeMake(300, 300) complete:^(UIImage *image) {
                    [neasset setImage:image];
                    [neasset setLocalIdentifier:asset.localIdentifier];
                    [assets addObject:neasset];
                    if (assets.count == fetchResult.count) {
                        if ([NSThread currentThread].isMainThread) {
                            complete(assets);
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                complete(assets);
                            });
                        }
                    }
                }];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil);
            });
        }
    });
}
@end
