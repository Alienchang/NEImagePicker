//
//  NETakePhotoController.m
//  Test
//
//  Created by Chang Liu on 11/7/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "NETakePhotoController.h"
#import "NECropViewController.h"
#import "UIImage+NEImagePicker.h"
@interface NETakePhotoController ()
@property (nonatomic ,strong) UIButton *snapButton;
@property (nonatomic ,strong) UIButton *switchButton;
@property (nonatomic ,strong) UIButton *closeButton;


@end

@implementation NETakePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.cameraController attachToViewController:self withFrame:self.view.bounds];
    [self.cameraController setFixOrientationAfterCapture:NO];
    
    [self.view addSubview:self.snapButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.closeButton];
    
    [self.snapButton setFrame:CGRectMake(0, 0, 74, 74)];
    [self.snapButton setCenter:CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - 40 - 74 / 2)];
    [self.snapButton setImage:[UIImage neip_named:@"ic_camera_take"] forState:UIControlStateNormal];
    
    [self.switchButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 28 - 44, self.snapButton.center.y + 22, 44, 44)];
    [self.closeButton setFrame:CGRectMake(28, self.snapButton.center.y + 22, 44, 44)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraController start];
}
#pragma mark -- getter
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage neip_named:@"ic_camera_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}
- (UIButton *)snapButton {
    if (!_snapButton) {
        _snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
        _snapButton.clipsToBounds = YES;
        _snapButton.layer.cornerRadius = CGRectGetWidth(self.snapButton.frame) / 2.0f;
        _snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _snapButton.layer.borderWidth = 2.0f;
        _snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _snapButton.layer.shouldRasterize = YES;
        [_snapButton addTarget:self action:@selector(snapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_switchButton setc:self.snapButton.center.y];
        _switchButton.tintColor = [UIColor whiteColor];
        [_switchButton setImage:[UIImage neip_named:@"ic_camera_change"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (NECameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[NECameraController alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                               position:NECameraPositionRear
                                                           videoEnabled:NO];
    }
    return _cameraController;
}

#pragma mark -- private func
- (void)closeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)snapButtonAction:(UIButton *)sender {
    //点击拍照
    __weak typeof(self) weakSelf = self;
    [self.cameraController capture:^(NECameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if (!error) {
            if (weakSelf.takePhotoComplete) {
                weakSelf.takePhotoComplete(image);
            }
        } else {
            
        }
    } exactSeenImage:YES];
}
- (void)switchButtonAction:(UIButton *)sender {
    //切换摄像头
    [self.cameraController togglePosition];
}

@end
