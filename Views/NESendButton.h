//
//  NESendButton.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NESendButton : UIView

@property (nonatomic ,assign) BOOL enabled;
@property (nonatomic, copy)   NSString *badgeValue;
@property (nonatomic ,strong) UIColor *enabledColor;
@property (nonatomic ,strong) UIColor *disabledColor;
@property (nonatomic ,copy)   NSString *titleText;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addTaget:(id)target action:(SEL)action;

@end
