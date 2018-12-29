//
//  NEFullImageButton.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEFullImageButton.h"

#define kDNFullImageButtonFont  [UIFont systemFontOfSize:13]
static NSInteger const buttonPadding = 10;
static NSInteger const buttonImageWidth = 16;

@interface NEFullImageButton ()
@property (nonatomic, strong) UIButton *fullImageButton;
@property (nonatomic, strong) UILabel *imageSizeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation NEFullImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth([[UIScreen mainScreen] bounds])/2 -20, 28);
        [self setFrame:rect];
        [self fullImageButton];
        [self imageSizeLabel];
        [self indicatorView];
        self.selected = NO;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.fullImageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)imageSizeLabel
{
    if (nil == _imageSizeLabel) {
        _imageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 4, CGRectGetWidth(self.frame)- 100, 20)];
        _imageSizeLabel.backgroundColor = [UIColor clearColor];
        _imageSizeLabel.font = [UIFont systemFontOfSize:14.0f];
        _imageSizeLabel.textAlignment = NSTextAlignmentLeft;
        _imageSizeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_imageSizeLabel];
    }
    return _imageSizeLabel;
}

- (UIButton *)fullImageButton
{
    if (nil == _fullImageButton) {
        _fullImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullImageButton setFrame:CGRectMake(0, 0, [self fullImageButtonWidth], 28)];
        _fullImageButton.backgroundColor = [UIColor clearColor];
        [_fullImageButton setTitle:NSLocalizedStringFromTable(@"fullImage", @"NEImagePicker", @"原图") forState:UIControlStateNormal];
        _fullImageButton.titleLabel.font = kDNFullImageButtonFont;
        [_fullImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_fullImageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_fullImageButton setImage:[UIImage imageNamed:@"photo_full_image_unselected"] forState:UIControlStateNormal];
        [_fullImageButton setImage:[UIImage imageNamed:@"photo_full_image_selected"] forState:UIControlStateSelected];
        _fullImageButton.contentVerticalAlignment = NSTextAlignmentRight;
        [_fullImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, buttonPadding - buttonImageWidth, 6, 0)];
        [_fullImageButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, CGRectGetWidth(_fullImageButton.frame) - buttonImageWidth)];
        [self addSubview:_fullImageButton];
    }
    return _fullImageButton;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (nil == _indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.fullImageButton.frame), 2, 26, 26)];
        _indicatorView.hidesWhenStopped = YES;
        [_indicatorView stopAnimating];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (CGFloat)fullImageButtonWidth
{
    NSString *string = NSLocalizedStringFromTable(@"fullImage", @"NEImagePicker", @"原图");
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:kDNFullImageButtonFont} context:nil];
    CGFloat width = buttonImageWidth + buttonPadding + CGRectGetWidth(rect);
    return width;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        self.fullImageButton.selected = _selected;
        CGRect imageButtonFrame = self.fullImageButton.frame;
        [self.fullImageButton setFrame:CGRectMake(CGRectGetMinX(imageButtonFrame), CGRectGetMinY(imageButtonFrame), [self fullImageButtonWidth], CGRectGetHeight(imageButtonFrame))];
        
        [self.fullImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, buttonPadding-buttonImageWidth, 6, 0)];
        [self.fullImageButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, CGRectGetWidth(imageButtonFrame) - buttonImageWidth)];
        CGFloat labelWidth = CGRectGetWidth(self.frame) - CGRectGetWidth(self.fullImageButton.frame);
        [self.imageSizeLabel setFrame:CGRectMake(CGRectGetWidth(imageButtonFrame), CGRectGetMinY(self.imageSizeLabel.frame), labelWidth, CGRectGetHeight(self.imageSizeLabel.frame))];
        self.imageSizeLabel.hidden = !_selected;
    }
}

- (void)setText:(NSString *)text
{
    self.imageSizeLabel.text = text;
}

- (void)shouldAnimating:(BOOL)animate
{
    if (self.selected) {
        self.imageSizeLabel.hidden = animate;
        if (animate) {
            [self.indicatorView startAnimating];
        } else {
            [self.indicatorView stopAnimating];
        }
    }
}
@end
