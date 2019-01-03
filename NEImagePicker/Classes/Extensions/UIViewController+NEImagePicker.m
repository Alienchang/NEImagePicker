//
//  UIViewController+NEImagePicker.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "UIViewController+NEImagePicker.h"
#import "UIColor+Hex.h"

@implementation UIViewController (NEImagePicker)
- (void)createBarButtonItemAtPosition:(NEImagePickerNavigationBarPosition)position statusNormalImage:(UIImage *)normalImage statusHighlightImage:(UIImage *)highlightImage action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (position) {
        case NEImagePickerNavigationBarPositionLeft:
            insets = UIEdgeInsetsMake(0, -20, 0, 20);
            break;
        case NEImagePickerNavigationBarPositionRight:
            insets = UIEdgeInsetsMake(0, 13, 0, -13);
            break;
        default:
            break;
    }
    
    [button setImageEdgeInsets:insets];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    switch (position) {
        case NEImagePickerNavigationBarPositionLeft:
            self.navigationItem.leftBarButtonItem = barButtonItem;
            break;
        case NEImagePickerNavigationBarPositionRight:
            self.navigationItem.rightBarButtonItem = barButtonItem;
            break;
        default:
            break;
    }
}

- (void)createBarButtonItemAtPosition:(NEImagePickerNavigationBarPosition)position text:(NSString *)text action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (position) {
        case NEImagePickerNavigationBarPositionLeft:
            insets = UIEdgeInsetsMake(0, -49 + 26, 0, 19);
            break;
        case NEImagePickerNavigationBarPositionRight:
            insets = UIEdgeInsetsMake(0, 49 - 26, 0, -19);
            break;
        default:
            break;
    }

    [button setTitleEdgeInsets:insets];
    [button setFrame:CGRectMake(0, 0, 64, 30)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    switch (position) {
        case NEImagePickerNavigationBarPositionLeft:
            self.navigationItem.leftBarButtonItem = barButtonItem;
            break;
        case NEImagePickerNavigationBarPositionRight:
            self.navigationItem.rightBarButtonItem = barButtonItem;
            break;
        default:
            break;
    }
}

- (void)createBackBarButtonItemStatusNormalImage:(UIImage *)normalImage statusHighlightImage:(UIImage *)highlightImage withTitle:(NSString *)title action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 84, 44)];
    [button setTitleColor:[UIColor colorWithRed:255/ 255. green:89/ 255. blue:106/ 255. alpha:1] forState:UIControlStateNormal];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, -20, 0, 60);
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, -45, 0, -15);
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setImageEdgeInsets:imageInsets];
    [button setTitleEdgeInsets:titleInsets];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

@end
