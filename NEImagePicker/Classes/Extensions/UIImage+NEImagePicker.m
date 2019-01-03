//
//  UIImage+NEImagePicker.m
//  NESocialClient
//
//  Created by Chang Liu on 11/1/17.
//  Copyright © 2017 Next Entertainment. All rights reserved.
//

#import "UIImage+NEImagePicker.h"

@implementation UIImage (NEImagePicker)
+ (UIImage *)neip_named:(NSString *)name {
    NSString *pathName = [self neip_pathWithImageName:name];
    UIImage *image = [UIImage imageNamed:pathName];
    return image;
}

+ (NSString *)neip_pathWithImageName:(NSString *)name{
    if (name.length == 0) {
        return nil;
    }
    NSString *imageName = [name copy];
    
    if ([imageName hasPrefix:@"NEImagePicker.bundle"]) {
        NSString *replaceStr = [NSString stringWithFormat:@"%@//",@"NEImagePicker.bundle"];
        imageName = [imageName stringByReplacingOccurrencesOfString:replaceStr withString:@""];
    }
    
    NSString *pathName = [@"NEImagePicker.bundle" stringByAppendingPathComponent:imageName];
    return pathName;
}
@end
