//
//  NEPreviewViewController.m
//  NEImagePicker
//
//  Created by Chang Liu on 9/12/18.
//

#import "NEPreviewController.h"

@interface NEPreviewController ()
@property (nonatomic ,strong) UIImageView *imageView;
@end

@implementation NEPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.imageView];
    [self.imageView setFrame:self.view.bounds];
     __weak typeof(self) weakSelf = self;
    [self.asset fetchImageFull:NEImagePickerImaageSizeFull complete:^(UIImage *image) {
        [weakSelf.imageView setImage:image];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageView;
}

@end
