//
//  UIImagePickerController+Fixed.m
//  MeMe
//
//  Created by MeMe on 16/3/3.
//  Copyright © 2017年 MeMe. All rights reserved.
//

/*
 *  修改系统imagePicker样式
 */

#import "UIImagePickerController+Fixed.h"

@implementation UIImagePickerController (Fixed)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationBar setTintColor:[UIColor blueColor]];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:self.navigationController.navigationBar.tintColor,
                                                           NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
}


@end
