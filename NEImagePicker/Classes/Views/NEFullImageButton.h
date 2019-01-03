//
//  NEFullImageButton.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEFullImageButton : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action;
- (void)shouldAnimating:(BOOL)animate;
@end
