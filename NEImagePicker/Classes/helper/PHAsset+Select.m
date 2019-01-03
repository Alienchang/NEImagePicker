//  MediaCenter
//
//  Created by Alienchang on 2016/12/5.
//  Copyright © 2016年 Alienchang. All rights reserved.
//
#import "PHAsset+Select.h"
#import <objc/runtime.h>
@implementation PHAsset (Select)
static void * PHAssetSelectedKey    = (void *)@"PHAssetSelectedKey";
static void * PHAssetThumbImageKey  = (void *)@"PHAssetThumbImageKey";

- (void)setSelected:(id)selected
{
    objc_setAssociatedObject(self, PHAssetSelectedKey, selected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)selected
{
    return objc_getAssociatedObject(self, PHAssetSelectedKey);
}


- (void)setThumbImage:(id)thumbImage
{
    objc_setAssociatedObject(self, PHAssetThumbImageKey, thumbImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)thumbImage
{
    return objc_getAssociatedObject(self, PHAssetThumbImageKey);
}

@end
