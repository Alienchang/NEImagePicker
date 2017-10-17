//
//  NEImageFlowViewController.h
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEImageFlowViewController : UIViewController
@property (nonatomic ,copy)   NSString *confirmText;
@property (nonatomic ,assign) NSUInteger limiteCount;
- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL;
@end
