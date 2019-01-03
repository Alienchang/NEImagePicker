//
//  NEAsset.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEAsset.h"
#import "NSURL+NEIMagePickerUrlEqual.h"
#import "NEImageHelper.h"
@implementation NEAsset
- (NSInteger)imageSize {
    return 0;
}
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

- (void)fetchImageFull:(NEImagePickerImaageSizeType)sizeType complete:(void (^)(UIImage *image))complete{
    if (self.image && !self.LocalIdentifier.length && !self.url.absoluteString.length) {
        if (complete) {
            complete(self.image);
        }
    } else {
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        PHFetchResult *fetchResult = nil;
        if (self.LocalIdentifier.length) {
            fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[self.LocalIdentifier] options:fetchOptions];
        } else {
            fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[self.url] options:fetchOptions];
        }
        
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
                    imageSize = CGSizeMake(200, 200);
                }
                    break;
                default:
                {
                    imageSize = CGSizeMake(100, 100);
                }
                    break;
            }
            
            [NEImageHelper getImageWithAsset:asset targetSize:imageSize complete:^(UIImage *image) {
                if (complete) {
                    complete(image);
                }
            }];
        } else {
            if (complete) {
                complete(nil);
            }
        }
    }
}


@end
