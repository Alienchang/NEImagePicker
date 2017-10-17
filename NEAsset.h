//
//  NEAsset.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum : NSUInteger {
    NEImagePickerImaageSizeFull,
    NEImagePickerImaageSizeFullScreen,
    NEImagePickerImaageSizeThumb,
} NEImagePickerImaageSizeType;

@interface NEAsset : NSObject

@property (nonatomic, strong) NSURL *url;  //ALAsset url
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic ,strong) UIImage *image;

- (BOOL)isEqualToAsset:(NEAsset *)asset;
- (void)fetchImageFull:(NEImagePickerImaageSizeType)sizeType complete:(void (^)(UIImage *))complete;
@end
