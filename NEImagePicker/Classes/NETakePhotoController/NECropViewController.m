//
//  NECropViewController.m
//  Test
//
//  Created by Chang Liu on 11/7/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import "NECropViewController.h"
#import <TOCropViewController/TOCropOverlayView.h>

@implementation NECropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cropView setCropRegionInsets:UIEdgeInsetsMake(0, -14, 30, -14)];
    [self setRotateButtonsHidden:YES];
    [self setRotateClockwiseButtonHidden:YES];
    [self setAspectRatioPickerButtonHidden:YES];
    [self setResetAspectRatioEnabled:NO];
    [self setAspectRatioLockEnabled:NO];
    
    
    self.cropView.frame = self.view.bounds;
    [self.cropView moveCroppedContentToCenterAnimated:NO];
    [self.toolbar setTintColor:[UIColor clearColor]];
    [self.toolbar setBackgroundColor:[UIColor clearColor]];
    [self.cropView.gridOverlayView setHidden:YES];
    [self.cropView setCropBoxResizeEnabled:NO];
    [self.toolbar setFrame:CGRectMake(CGRectGetMinX(self.toolbar.frame), CGRectGetMinY(self.toolbar.frame), CGRectGetWidth(self.toolbar.frame), 72)];
    
    
    CGPoint doneButtonCenter = self.toolbar.doneTextButton.center;
    [self.toolbar.doneTextButton setCenter:CGPointMake(doneButtonCenter.x, 8)];
    
    CGPoint cancelButtonCenter = self.toolbar.cancelTextButton.center;
    [self.toolbar.cancelTextButton setCenter:CGPointMake(cancelButtonCenter.x, 8)];
    [self.toolbar.doneTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.toolbar.cancelTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cropView setSimpleRenderMode:NO];
    
    [self.toolbar.resetButton setHidden:YES];
    [self.toolbar.rotateButton setHidden:YES];
    [self.toolbar.rotateCounterclockwiseButton setHidden:YES];
    [self.toolbar.clampButton setHidden:YES];
    [self.toolbar.rotateClockwiseButton setHidden:YES];
    [self.cropView setGridOverlayHidden:YES];
}

#pragma mark -- getter
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicatorView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    
}
@end
