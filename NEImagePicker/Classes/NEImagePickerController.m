//
//  NEImagePickerController.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEImagePickerController.h"
#import "NEAlbumTableViewController.h"
#import "NEImageFlowViewController.h"
#import <Photos/Photos.h>

NSString *kNEImagePickerStoredGroupKey = @"sc";

@interface NEImagePickerController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> navDelegate;
@property (nonatomic, assign) BOOL isDuringPushAnimation;

@end

@implementation NEImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!self.delegate) {
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
    NSString *propwetyID = [[NSUserDefaults standardUserDefaults] objectForKey:kNEImagePickerStoredGroupKey];
    __weak typeof(self) weakself = self;
    if (propwetyID.length <= 0) {
        [self showAlbumList];
    } else {
        PHFetchOptions *fetchOption = [PHFetchOptions new];
        if (@available(iOS 9.0, *)) {
            [fetchOption setIncludeAssetSourceTypes:PHAssetSourceTypeUserLibrary];
        } else {
            // Fallback on earlier versions
        }
        PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[propwetyID] options:fetchOption];
        if (result.count) {
            PHAssetCollection *assetCollection = result[0];
            NEAlbum *album = [NEAlbum new];
            [album setLocalIdentifier:propwetyID];
            [album setAlbumTitle:assetCollection.localizedTitle];
            [album fetchAlbumImage:^(UIImage *image) {
                NEAlbumTableViewController *albumTableViewController = [NEAlbumTableViewController new];
                [albumTableViewController setLimiteCount:weakself.limiteCount];
                [albumTableViewController setConfirmText:weakself.confirmText];
                NEImageFlowViewController *imageFlowController = [[NEImageFlowViewController alloc] initWithAlbum:album];
                [imageFlowController setConfirmText:weakself.confirmText];
                [imageFlowController setLimiteCount:weakself.limiteCount];
                [weakself setViewControllers:@[albumTableViewController,imageFlowController]];
            }];
        } else {
            [self showAlbumList];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - priviate methods
- (void)showAlbumList {
    NEAlbumTableViewController *albumTableViewController = [NEAlbumTableViewController new];
    [albumTableViewController setLimiteCount:self.limiteCount];
    [albumTableViewController setConfirmText:self.confirmText];
    [self setViewControllers:@[albumTableViewController]];
}

#pragma mark - UINavigationController

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    [super setDelegate:delegate ? self : nil];
    self.navDelegate = delegate != self ? delegate : nil;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated __attribute__((objc_requires_super)) {
    self.isDuringPushAnimation = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.isDuringPushAnimation = NO;
    if ([self.navDelegate respondsToSelector:_cmd]) {
        [self.navDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        return YES;
    }
}

#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s {
    return [super respondsToSelector:s] || [self.navDelegate respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s {
    return [super methodSignatureForSelector:s] ?: [(id)self.navDelegate methodSignatureForSelector:s];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    id delegate = self.navDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

- (void)lastAsset:(void (^)(NEAsset * _Nullable, NSError *_Nullable))block {
    PHFetchOptions *options = [PHFetchOptions new];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *phasset = [assetsFetchResults lastObject];
    if (phasset) {
        NEAsset *asset = [NEAsset new];
        [asset setLocalIdentifier:phasset.localIdentifier];
        block(asset ,nil);
    } else {
        block(nil ,nil);
    }
}

#pragma mark -- setter
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.navigationBar setTintColor:tintColor];
}
@end
