//
//  NETakePhotoController.h
//  Test
//
//  Created by Chang Liu on 11/7/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NECameraController.h"
@interface NETakePhotoController : UIViewController
@property (nonatomic ,strong) NECameraController *cameraController;
@property (nonatomic ,copy)   void(^takePhotoComplete)(UIImage *image);
@end
