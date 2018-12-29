//
//  Created by MeMe on 11/7/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NECameraController.h"

@interface NECameraController (Helper)

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
                                          previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer
                                                 ports:(NSArray<AVCaptureInputPort *> *)ports;

- (UIImage *)cropImage:(UIImage *)image usingPreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

@end
