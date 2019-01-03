//
//  NETapDetectingImageView.h
//  ImagePicker
//
//  Created by Ding Xiao on 9/5/17.
//  Copyright © 2016年 Dennis. All rights reserved.
//  In order to avoid confilict to MWTapDetectingImageView, Simplifing it to this class

#import <UIKit/UIKit.h>

@protocol NETapDetectingImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end

@interface NETapDetectingImageView : UIImageView
@property (nonatomic, weak) id <NETapDetectingImageViewDelegate> tapDelegate;
@end
