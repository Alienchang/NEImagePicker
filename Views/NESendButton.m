//
//  NESendButton.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NESendButton.h"
#import "UIView+NEImagePicker.h"
#import "UIColor+Hex.h"
#define kSendButtonFont  [UIFont systemFontOfSize:15]
static NSString *const NESendButtonTintNormalColor = @"#1FB823";
//static NSString *const NESendButtonTintAbnormalColor = @"#C9DCCA";
static NSString *const NESendButtonTintAbnormalColor = @"#C9EFCA";

static CGFloat const kSendButtonTextWitdh = 38.0f;

@interface NESendButton ()
@property (nonatomic, strong) UILabel *badgeValueLabel;
@property (nonatomic, strong) UIView *backGroudView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation NESendButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.left = 0;
        self.right = 0;
        self.top = 0;
        self.bottom = 0;
        self.width = 74;
        self.height = 33;
        [self setupViews];
        self.badgeValue = @"0";
    }
    return self;
}

- (void)setupViews
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
    gradientLayer.colors = @[
                             (__bridge id)[UIColor colorWithRed:255 /255. green:101 /255. blue:186 /255. alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:255 /255. green:90 /255. blue:91 /255. alpha:1].CGColor
                             ];
    
    gradientLayer.locations  = @[@(0),@(1)];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    [self.layer addSublayer:gradientLayer];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(0, 0, self.width, self.height);
    [_sendButton setTitle:[NSString stringWithFormat:@"%@(0)",self.titleText]
                 forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_sendButton setBackgroundColor:[UIColor clearColor]];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:_sendButton];
    
    [self.layer setCornerRadius:8.];
    [self.layer setMasksToBounds:YES];
    
    
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    [self.sendButton setTitle:[NSString stringWithFormat:@"%@(%@)",self.titleText,badgeValue]
                     forState:UIControlStateNormal];
}


- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [self.sendButton setTitle:[NSString stringWithFormat:@"%@(%@)",self.titleText,self.badgeValue]
                     forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    [self.sendButton setEnabled:enabled];
    if (enabled) {
        [self.sendButton setBackgroundColor:self.enabledColor];
    }else{
        [self.sendButton setBackgroundColor:self.disabledColor];
    }
}

- (void)setEnabledColor:(UIColor *)enabledColor{
    _enabledColor = enabledColor;
}
- (void)setDisabledColor:(UIColor *)disabledColor{
    _disabledColor = disabledColor;
}

- (void)showBadgeValue
{
    self.badgeValueLabel.hidden = NO;
    self.backGroudView.hidden = NO;
}

- (void)hideBadgeValue
{
    self.badgeValueLabel.hidden = YES;
    self.backGroudView.hidden = YES;
    self.sendButton.adjustsImageWhenDisabled = YES;
}


- (void)addTaget:(id)target action:(SEL)action
{
    [self.sendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
