//
//  NEAsset.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEAsset.h"
#import "NSURL+NEIMagePickerUrlEqual.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@implementation NEAsset

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return [self isEqualToAsset:other];
    }
}

- (BOOL)isEqualToAsset:(NEAsset *)asset
{
    if ([asset isKindOfClass:[NEAsset class]]) {
        return [self.url isEqualToOther:asset.url];
    } else {
        return NO;
    }
}

- (void)fetchImageFull:(NEImagePickerImaageSizeType)sizeType complete:(void (^)(UIImage *))complete{
    if (self.image) {
        if (complete) {
            complete(self.image);
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            ALAssetsLibrary *lib = [ALAssetsLibrary new];
            __weak typeof(self) weakSelf = self;
            [lib assetForURL:self.url resultBlock:^(ALAsset *asset){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (asset) {
                    UIImage *image = nil;
                    
                    switch (sizeType) {
                        case NEImagePickerImaageSizeFullScreen:
                        {
                            image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
                        }
                            break;
                        case NEImagePickerImaageSizeFull:
                        {
                            image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
                        }
                            break;
                        case NEImagePickerImaageSizeThumb:
                        {
                            image = [UIImage imageWithCGImage:asset.thumbnail];
                        }
                            break;
                        default:
                        {
                            image = [UIImage imageWithCGImage:asset.thumbnail];
                        }
                            break;
                    }
                    
                    if (complete) {
                        complete(image);
                    }
                } else {
                    // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                    [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                     {
                         [group enumerateAssetsWithOptions:NSEnumerationReverse
                                                usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    
                                                    if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:self.url])
                                                    {
                                                        UIImage *image = nil;
                                                        
                                                        switch (sizeType) {
                                                            case NEImagePickerImaageSizeFullScreen:
                                                            {
                                                                image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
                                                            }
                                                                break;
                                                            case NEImagePickerImaageSizeFull:
                                                            {
                                                                image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
                                                            }
                                                                break;
                                                            case NEImagePickerImaageSizeThumb:
                                                            {
                                                                image = [UIImage imageWithCGImage:asset.thumbnail];
                                                            }
                                                                break;
                                                            default:
                                                            {
                                                                image = [UIImage imageWithCGImage:asset.thumbnail];
                                                            }
                                                                break;
                                                        }
                                                        
                                                        if (complete) {
                                                            complete(image);
                                                        }
                                                    }
                                                }];
                     }
                                     failureBlock:^(NSError *error)
                     {
                         if (complete) {
                             complete(nil);
                         }
                     }];
                }
                
            } failureBlock:^(NSError *error){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (complete) {
                    complete(nil);
                }
            }];
#pragma clang diagnostic pop
        }else{
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[self.url] options:fetchOptions];
            if (fetchResult.count) {
                PHAsset *asset = fetchResult[0];
                
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.synchronous = YES;
                
                CGSize imageSize = CGSizeZero;
                
                switch (sizeType) {
                    case NEImagePickerImaageSizeFullScreen:
                    {
                        imageSize = [UIScreen mainScreen].bounds.size;
                    }
                        break;
                    case NEImagePickerImaageSizeFull:
                    {
                        imageSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                    }
                        break;
                    case NEImagePickerImaageSizeThumb:
                    {
                        imageSize = CGSizeMake(100, 100);
                    }
                        break;
                    default:
                    {
                        imageSize = CGSizeMake(100, 100);
                    }
                        break;
                }
                
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (complete) {
                        complete(result);
                    }
                }];
                
            }else{
                if (complete) {
                    complete(nil);
                }
            }
        }
    }
}


@end
