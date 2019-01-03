//
//  NEImageFlowViewController.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEImageFlowViewController.h"
#import "NEImagePickerController.h"
#import "NEPhotoBrowser.h"
#import "UIViewController+NEImagePicker.h"
#import "UIColor+Hex.h"
#import "NEAssetsViewCell.h"
#import "NESendButton.h"
#import "NEAsset.h"
#import "NSURL+NEIMagePickerUrlEqual.h"
#import <Photos/Photos.h>
#import "UIImage+NEImagePicker.h"
#import "NEImageHelper.h"
#import "NEPreviewController.h"

@interface NEImageFlowViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NEAssetsViewCellDelegate, NEPhotoBrowserDelegate ,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSURL *assetsGroupURL;

@property (nonatomic, strong) UICollectionView  *imageFlowCollectionView;
@property (nonatomic, strong) NESendButton      *sendButton;
@property (nonatomic ,strong) UIButton          *previewButton;
@property (nonatomic, strong) NSMutableArray <NEAsset *>*assetsArray;
@property (nonatomic, strong) NSMutableArray <NEAsset *>*selectedAssetsArray;
@property (nonatomic, assign) BOOL isFullImage;
@property (nonatomic ,strong) NEAlbum *album;
@property (nonatomic ,assign) BOOL didAppBarIsTranslucent;

@end

static NSString* const NEAssetsViewCellReuseIdentifier = @"NEAssetsViewCell";

@implementation NEImageFlowViewController

- (instancetype)initWithAlbum:(NEAlbum *)album {
    self = [super init];
    if (self) {
        _album = album;
        _assetsArray = [NSMutableArray new];
        _selectedAssetsArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
    
    if ([self NEImagePickerController].open3DTouch) {
        if (@available(iOS 9.0, *)) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                // 添加3D touch 监听
                [self registerForPreviewingWithDelegate:self sourceView:self.view];
            }
        } else {
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup view and data
- (void)setupData {
    [self setTitle:self.album.albumTitle];
    [self loadData];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self NEImagePickerController].sourceConfig.navigationBackImage) {
        [self createBarButtonItemAtPosition:NEImagePickerNavigationBarPositionLeft
                          statusNormalImage:[self NEImagePickerController].sourceConfig.navigationBackImage
                       statusHighlightImage:[self NEImagePickerController].sourceConfig.navigationBackImage
                                     action:@selector(backButtonAction)];
    }
    
    [self createBarButtonItemAtPosition:NEImagePickerNavigationBarPositionRight
                                   text:NSLocalizedString(@"Cancel", nil)
                                 action:@selector(cancelAction)];
    
    [self imageFlowCollectionView];
    [self.previewButton setTitle:NSLocalizedString(@"Preview",nil) forState:UIControlStateNormal];
    [self.previewButton sizeToFit];
    [self.previewButton addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.previewButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item4.width = -10;
    
    [self setToolbarItems:@[item1,item2,item3,item4] animated:NO];
    [self.navigationController.toolbar setBarTintColor:[UIColor whiteColor]];
    
    if (UINavigationBar.appearance.isTranslucent) {
        [self.navigationController.toolbar setTranslucent:NO];
    } else {
        [self.navigationController.toolbar setTranslucent:YES];
    }
    
    
    [self.previewButton setEnabled:NO];
    [self.sendButton setEnabled:NO];
    item1.enabled = NO;
    [self.view addSubview:self.imageFlowCollectionView];
    
    if (!UINavigationBar.appearance.isTranslucent) {
        UIEdgeInsets edgeInsets;
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            if (!window && UIApplication.sharedApplication.windows.count) {
                window = UIApplication.sharedApplication.windows[0];
            }
            edgeInsets = window.safeAreaInsets;
        } else {
            edgeInsets = UIEdgeInsetsZero;
        }
        
        [self.imageFlowCollectionView setFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64 - edgeInsets.bottom)];
    } else {
        [self.imageFlowCollectionView setFrame:self.view.bounds];
    }
}

- (void)loadData {
    __weak typeof(self) weakself = self;
    [self.album fetchAssetsWithoutImage:^(NSArray<NEAsset *>*assets) {
        [weakself.assetsArray addObjectsFromArray:assets];
        [weakself.imageFlowCollectionView reloadData];
        [weakself.imageFlowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:weakself.assetsArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }];
}

#pragma mark - helpmethods
- (void)scrollerToBottom:(BOOL)animated {
    NSInteger rows = [self.imageFlowCollectionView numberOfItemsInSection:0] - 1;
    [self.imageFlowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:rows inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}

- (NEImagePickerController *)NEImagePickerController {
    if (nil == self.navigationController
        ||
        NO == [self.navigationController isKindOfClass:[NEImagePickerController class]])
    {
        return nil;
    }
    return (NEImagePickerController *)self.navigationController;
}

- (BOOL)assetIsSelected:(NEAsset *)targetAsset {
    for (NEAsset *asset in self.selectedAssetsArray) {
        NSURL *assetURL = asset.url;
        NSURL *targetAssetURL = targetAsset.url;
        if ([assetURL isEqualToOther:targetAssetURL] || asset.image == targetAsset.image) {
            return YES;
        }
    }
    return NO;
}

- (void)removeAssetsObject:(NEAsset *)asset {
    if ([self assetIsSelected:asset]) {
        [self.selectedAssetsArray removeObject:asset];
    }
}

- (void)addAssetsObject:(NEAsset *)asset {
    if (!asset) {
        return;
    }
    [self.selectedAssetsArray addObject:asset];
}

- (NEAsset *)NEassetFromALAsset:(ALAsset *)ALAsset {
    NEAsset *asset = [[NEAsset alloc] init];
    asset.url = [ALAsset valueForProperty:ALAssetPropertyAssetURL];
    return asset;
}

- (NSArray *)seletedDNAssetArray {
    return self.selectedAssetsArray;
}

#pragma mark - priviate methods
- (void)sendImages {
    [[NSUserDefaults standardUserDefaults] setObject:self.album.localIdentifier forKey:kNEImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NEImagePickerController *imagePicker = [self NEImagePickerController];
    if (imagePicker && [imagePicker.imagePickerDelegate respondsToSelector:@selector(neImagePickerController:imageAssets:isFullImage:)]) {
        [imagePicker.imagePickerDelegate neImagePickerController:imagePicker imageAssets:[self seletedDNAssetArray] isFullImage:self.isFullImage];
        if ([imagePicker.imagePickerDelegate respondsToSelector:@selector(neImagePickerControllerDidSelected:)]) {
            [imagePicker.imagePickerDelegate neImagePickerControllerDidSelected:imagePicker];
        }
    }
    
    NEImagePickerController *navController = [self NEImagePickerController];
    if (![navController.imagePickerDelegate respondsToSelector:@selector(neImagePickerControllerDidSelected:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)browserPhotoAsstes:(NSArray *)assets pageIndex:(NSInteger)page {
    NEPhotoBrowser *browser = [[NEPhotoBrowser alloc] initWithAssets:assets currentIndex:page fullImage:self.isFullImage];
    [self.navigationController pushViewController:browser animated:YES];
    [browser setTintColor:[self NEImagePickerController].tintColor];
    [browser setDisableTintColor:[self NEImagePickerController].disableTintColor];
    [browser.sendButton setTitleText:self.confirmText];
    [browser.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    browser.delegate = self;
    browser.hidesBottomBarWhenPushed = YES;
}

- (BOOL)seletedAssets:(NEAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        return NO;
    }
    UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
    [self.previewButton setEnabled:YES];
    [self.sendButton setEnabled:YES];
    firstItem.enabled = YES;
    if (self.selectedAssetsArray.count >= self.limiteCount) {
        //NSLocalizedStringFromTable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"Select a maximum of %ld photos", nil),self.limiteCount] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else {
        [self addAssetsObject:asset];
        self.sendButton.badgeValue = [NSString stringWithFormat:@"%@",@(self.selectedAssetsArray.count)];
        return YES;
    }
}

- (void)deseletedAssets:(NEAsset *)asset {
    [self removeAssetsObject:asset];
    self.sendButton.badgeValue = [NSString stringWithFormat:@"%@",@(self.selectedAssetsArray.count)];
    if (self.selectedAssetsArray.count < 1) {
        UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
        firstItem.enabled = NO;
        [self.previewButton setEnabled:NO];
        [self.sendButton setEnabled:NO];
    }
}

#pragma mark - getter/setter
- (UICollectionView *)imageFlowCollectionView {
    if (nil == _imageFlowCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat toolBarHeight = 0;
        if (![UINavigationBar appearance].isTranslucent) {
            toolBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
        }
        _imageFlowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageFlowCollectionView.backgroundColor = [UIColor clearColor];
        [_imageFlowCollectionView registerClass:[NEAssetsViewCell class] forCellWithReuseIdentifier:NEAssetsViewCellReuseIdentifier];
        
        _imageFlowCollectionView.alwaysBounceVertical = YES;
        _imageFlowCollectionView.delegate = self;
        _imageFlowCollectionView.dataSource = self;
        _imageFlowCollectionView.showsHorizontalScrollIndicator = YES;
    }
    
    return _imageFlowCollectionView;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 18)];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_previewButton setTitleColor:[self NEImagePickerController].tintColor forState:UIControlStateNormal];
        [_previewButton setTitleColor:[self NEImagePickerController].disableTintColor forState:UIControlStateDisabled];
    }
    return _previewButton;
}

- (NESendButton *)sendButton {
    if (nil == _sendButton) {
        _sendButton = [[NESendButton alloc] initWithFrame:CGRectMake(0, 0, 74, 33)];
        [_sendButton addTaget:self action:@selector(sendButtonAction:)];
        [_sendButton setTitleText:self.confirmText];
        [_sendButton setEnabled:NO];
        [_sendButton setDisabledColor:[self NEImagePickerController].disableTintColor];
        [_sendButton setEnabledColor:[self NEImagePickerController].tintColor];
        [_sendButton setDisabledTitleColor:[self NEImagePickerController].disableTitleColor];
        [_sendButton setEnabledTitleColor:[self NEImagePickerController].enableTitleColor];
    }
    return  _sendButton;
}

#pragma mark - ui action
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonAction:(id)sender {
    if (self.selectedAssetsArray.count > 0) {
        [self sendImages];
    }
}

- (void)previewAction {
    [self browserPhotoAsstes:self.selectedAssetsArray pageIndex:0];
}

- (void)cancelAction {
    NEImagePickerController *navController = [self NEImagePickerController];
    if (navController && [navController.imagePickerDelegate respondsToSelector:@selector(neImagePickerControllerDidCancel:)]) {
        [navController.imagePickerDelegate neImagePickerControllerDidCancel:navController];
    }
}

#pragma mark - NEAssetsViewCellDelegate
- (void)didSelectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell {
    
    NSIndexPath *indexPath = [self.imageFlowCollectionView indexPathForCell:assetsCell];
    assetsCell.isSelected = [self seletedAssets:self.assetsArray[indexPath.row]];
}

- (void)didDeselectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell {
    assetsCell.isSelected = NO;
    NSIndexPath *indexPath = [self.imageFlowCollectionView indexPathForCell:assetsCell];
    [self deseletedAssets:self.assetsArray[indexPath.row]];
}

#pragma mark - UICollectionView delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NEAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NEAssetsViewCellReuseIdentifier forIndexPath:indexPath];
    NEAsset *asset = self.assetsArray[indexPath.row];
    [cell setSelectedImageIcon:[self NEImagePickerController].sourceConfig.imageSelectedIcon];
    [cell setUnselectedImageIcon:[self NEImagePickerController].sourceConfig.imageunselectedIcon];
    cell.delegate = self;
    [cell fillWithAsset:asset isSelected:[self assetIsSelected:asset]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self browserPhotoAsstes:self.assetsArray pageIndex:indexPath.row];
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - NEPhotoBrowserDelegate
- (void)ne_sendImagesFromPhotobrowser:(NEPhotoBrowser *)photoBrowser currentAsset:(NEAsset *)asset {
    if (self.selectedAssetsArray.count <= 0) {
        [self seletedAssets:asset];
        [self.imageFlowCollectionView reloadData];
    }
    [self sendImages];
}

- (NSUInteger)ne_seletedPhotosNumberInPhotoBrowser:(NEPhotoBrowser *)photoBrowser {
    return self.selectedAssetsArray.count;
}

- (BOOL)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(NEAsset *)asset {
    
    return [self assetIsSelected:asset];
}

- (BOOL)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser seletedAsset:(NEAsset *)asset {
    BOOL seleted = [self seletedAssets:asset];
    [self.imageFlowCollectionView reloadData];
    return seleted;
}

- (void)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser deseletedAsset:(NEAsset *)asset {
    [self deseletedAssets:asset];
    [self.imageFlowCollectionView reloadData];
}

- (void)ne_photoBrowser:(NEPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage {
    self.isFullImage = fullImage;
}

- (void)dealloc {
}

#pragma mark -- getter
- (NSUInteger)limiteCount {
    if (!_limiteCount) {
        _limiteCount = 9;
    }
    return _limiteCount;
}

#pragma mark -- UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NEPreviewController *viewController = [[self NEImagePickerController].touchPreviewImageControllerClass new];
    CGPoint point = [self.imageFlowCollectionView convertPoint:location fromView:self.view];
    /** 通过坐标活的当前cell indexPath */
    NSIndexPath *indexPath = [self.imageFlowCollectionView indexPathForItemAtPoint:point];
    /** 获得当前cell */
    NEAssetsViewCell *cell = (NEAssetsViewCell *)[self.imageFlowCollectionView cellForItemAtIndexPath:indexPath];
    [viewController setAsset:cell.asset];
    return viewController;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}
@end
