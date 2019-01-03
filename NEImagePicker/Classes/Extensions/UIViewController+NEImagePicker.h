//
//  UIViewController+NEImagePicker.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NEImagePickerNavigationBarPosition) {
    NEImagePickerNavigationBarPositionLeft,
    NEImagePickerNavigationBarPositionRight
};


@interface UIViewController (NEImagePicker)

/**
 *  根据image创建导航栏左右item
 *
 *  @param position       左右位置
 *  @param normalImage    normal状态image
 *  @param highlightImage highlight状态image
 *  @param action         动作
 */
- (void)createBarButtonItemAtPosition:(NEImagePickerNavigationBarPosition)position
                    statusNormalImage:(UIImage *)normalImage
                 statusHighlightImage:(UIImage *)highlightImage
                               action:(SEL)action;

/**
 *  根据文本创建导航栏左右item
 *
 *  @param position 左右位置
 *  @param text     文本
 *  @param action   动作
 */
- (void)createBarButtonItemAtPosition:(NEImagePickerNavigationBarPosition)position
                                 text:(NSString *)text
                               action:(SEL)action;

/**
 *  根据image创建导航栏左item
 *
 *  @param normalImage    normal状态image
 *  @param highlightImage highlight状态image
 *  @param title  返回按钮title
 *  @param action         动作
 */
- (void)createBackBarButtonItemStatusNormalImage:(UIImage *)normalImage
                            statusHighlightImage:(UIImage *)highlightImage
                                       withTitle:(NSString *)title
                                          action:(SEL)action;


@end
