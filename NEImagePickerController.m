//
//  NEImagePickerController.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "NEImagePickerController.h"
#import "NEAlbumTableViewController.h"
#import "NEImageFlowViewController.h"
#import <Photos/Photos.h>

NSString *kNEImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-deprecated"
ALAssetsFilter * ALAssetsFilterFromDNImagePickerControllerFilterType(NEImagePickerFilterType type)
{
    switch (type) {
        default:
        case NEImagePickerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
        case NEImagePickerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
        case NEImagePickerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}
#pragma clang diagnostic pop

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

    if (propwetyID.length <= 0) {
        [self showAlbumList];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        ALAssetsLibrary *assetsLibiary = [[ALAssetsLibrary alloc] init];
        [assetsLibiary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop)
         {
             if (assetsGroup == nil && *stop ==  NO) {
                 [self showAlbumList];
             }
             
             NSString *assetsGroupID = [assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
             if ([assetsGroupID isEqualToString:propwetyID]) {
                 *stop = YES;
                 NSURL *assetsGroupURL = [assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
                 NEAlbumTableViewController *albumTableViewController = [[NEAlbumTableViewController alloc] init];
                 [albumTableViewController setLimiteCount:self.limiteCount];
                 [albumTableViewController setConfirmText:self.confirmText];
                 NEImageFlowViewController *imageFlowController = [[NEImageFlowViewController alloc] initWithGroupURL:assetsGroupURL];
                 [imageFlowController setConfirmText:self.confirmText];
                 [imageFlowController setLimiteCount:self.limiteCount];
                 [self setViewControllers:@[albumTableViewController,imageFlowController]];
             }
         }
                                   failureBlock:^(NSError *error)
         {
             [self showAlbumList];
         }];
#pragma clang diagnostic pop
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - priviate methods
- (void)showAlbumList
{
    NEAlbumTableViewController *albumTableViewController = [[NEAlbumTableViewController alloc] init];
    [albumTableViewController setLimiteCount:self.limiteCount];
    [albumTableViewController setConfirmText:self.confirmText];
    [self setViewControllers:@[albumTableViewController]];
}

#pragma mark - UINavigationController

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    [super setDelegate:delegate ? self : nil];
    self.navDelegate = delegate != self ? delegate : nil;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated __attribute__((objc_requires_super))
{
    self.isDuringPushAnimation = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    self.isDuringPushAnimation = NO;
    if ([self.navDelegate respondsToSelector:_cmd]) {
        [self.navDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        return YES;
    }
}

#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s
{
    return [super respondsToSelector:s] || [self.navDelegate respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s
{
    return [super methodSignatureForSelector:s] ?: [(id)self.navDelegate methodSignatureForSelector:s];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id delegate = self.navDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

- (void)lastAsset:(void (^)(NEAsset * _Nullable, NSError *_Nullable))block {
    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            __block NSInteger i = 0;
            [group enumerateAssetsWithOptions:NSEnumerationReverse/*遍历方式-反向*/ usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NEAsset *asset = [NEAsset new];
                    asset.url = [result valueForProperty:ALAssetPropertyAssetURL];
                    if (i == 0) {
                        block(asset ,nil);
                    }
                    return;
                }else{
                    if (i == 0) {
                        block(nil ,nil);
                    }
                }
                ++ i;
            }];
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            block(nil ,error);
        }
    }];
}
@end
