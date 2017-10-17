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
#import "UIView+NEImagePicker.h"
#import "UIColor+Hex.h"
#import "NEAssetsViewCell.h"
#import "NESendButton.h"
#import "NEAsset.h"
#import "NSURL+NEIMagePickerUrlEqual.h"
#import "UIImage+NEChat.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface NEImageFlowViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NEAssetsViewCellDelegate, NEPhotoBrowserDelegate>

@property (nonatomic, strong) NSURL *assetsGroupURL;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, strong) UICollectionView *imageFlowCollectionView;
@property (nonatomic, strong) NESendButton *sendButton;

@property (nonatomic ,strong) UIButton *previewButton;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;

@property (nonatomic, assign) BOOL isFullImage;
@end

static NSString* const NEAssetsViewCellReuseIdentifier = @"NEAssetsViewCell";

@implementation NEImageFlowViewController



- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL
{
    self = [super init];
    if (self) {
        _assetsArray = [NSMutableArray new];
        _selectedAssetsArray = [NSMutableArray new];
        _assetsGroupURL = assetsGroupURL;
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup view and data
- (void)setupData
{
    [_assetsLibrary groupForURL:self.assetsGroupURL resultBlock:^(ALAssetsGroup *assetsGroup){
        self.assetsGroup = assetsGroup;
        if (self.assetsGroup) {
            self.title =[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
            [self loadData];
        }
        
    } failureBlock:^(NSError *error){
        //            NSLog(@"%@",error.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}


- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBarButtonItemAtPosition:NEImagePickerNavigationBarPositionLeft
                      statusNormalImage:[UIImage imageNamed:@"btn-nav-back"]
                   statusHighlightImage:[UIImage imageNamed:@"btn-nav-back"]
                                 action:@selector(backButtonAction)];
    [self createBarButtonItemAtPosition:NEImagePickerNavigationBarPositionRight
                                   text:NSLocalizedString(@"Cancel", comment: "")
                                 action:@selector(cancelAction)];
    
    
    
    [self imageFlowCollectionView];
    
    [self.previewButton setTitle:NSLocalizedString(@"Preview", @"") forState:UIControlStateNormal];
    [self.previewButton sizeToFit];
    [self.previewButton addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.previewButton];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item4.width = -10;
    
    [self setToolbarItems:@[item1,item2,item3,item4] animated:NO];
    [self.navigationController.toolbar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.toolbar setTranslucent:NO];
    
    [self.previewButton setEnabled:NO];
    [self.sendButton setEnabled:NO];
    item1.enabled = NO;
}

- (void)loadData
{
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromDNImagePickerControllerFilterType([[self NEImagePickerController] filterType])];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.assetsArray insertObject:result atIndex:0];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageFlowCollectionView reloadData];
            [self scrollerToBottom:NO];
        });
    });
}

#pragma mark - helpmethods
- (void)scrollerToBottom:(BOOL)animated
{
    NSInteger rows = [self.imageFlowCollectionView numberOfItemsInSection:0] - 1;
    [self.imageFlowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:rows inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}

- (NEImagePickerController *)NEImagePickerController
{
    
    if (nil == self.navigationController
        ||
        NO == [self.navigationController isKindOfClass:[NEImagePickerController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (NEImagePickerController *)self.navigationController;
}

- (BOOL)assetIsSelected:(ALAsset *)targetAsset
{
    for (ALAsset *asset in self.selectedAssetsArray) {
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        NSURL *targetAssetURL = [targetAsset valueForProperty:ALAssetPropertyAssetURL];
        if ([assetURL isEqualToOther:targetAssetURL]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeAssetsObject:(ALAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        [self.selectedAssetsArray removeObject:asset];
    }
}

- (void)addAssetsObject:(ALAsset *)asset
{
    [self.selectedAssetsArray addObject:asset];
}

- (NEAsset *)NEassetFromALAsset:(ALAsset *)ALAsset
{
    NEAsset *asset = [[NEAsset alloc] init];
    asset.url = [ALAsset valueForProperty:ALAssetPropertyAssetURL];
    return asset;
}

- (NSArray *)seletedDNAssetArray
{
    NSMutableArray *seletedArray = [NSMutableArray new];
    for (ALAsset *asset in self.selectedAssetsArray) {
        NEAsset *NEasset = [self NEassetFromALAsset:asset];
        [seletedArray addObject:NEasset];
    }
    return seletedArray;
}

#pragma mark - priviate methods
- (void)sendImages
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSString *properyID = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    [[NSUserDefaults standardUserDefaults] setObject:properyID forKey:kNEImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NEImagePickerController *imagePicker = [self NEImagePickerController];
    if (imagePicker && [imagePicker.imagePickerDelegate respondsToSelector:@selector(neImagePickerController:imageAssets:isFullImage:)]) {
        [imagePicker.imagePickerDelegate neImagePickerController:imagePicker imageAssets:[self seletedDNAssetArray] isFullImage:self.isFullImage];
    }
    if (imagePicker && [imagePicker.imagePickerDelegate respondsToSelector:@selector(neImagePickerController:images:isFullImage:)]) {
        
        NSMutableArray *imagesArray = [NSMutableArray new];
       
        @autoreleasepool {
            __block NSInteger sign = 0;
            for (NEAsset *dnasset in [self seletedDNAssetArray]) {
                ALAssetsLibrary *lib = [ALAssetsLibrary new];
                __weak typeof(self) weakSelf = self;
                [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
                    sign ++;
                    ALAssetRepresentation *image_representation = [asset defaultRepresentation];
                    UIImage *image = [UIImage imageWithCGImage:image_representation.fullResolutionImage];
                    image = [image resizewitdhXaxWidth:1280 maxHeight:1280];
                    image = [image fixOrientation:image_representation.orientation];
                    if (image) {
                        [imagesArray addObject:image];
                    }
                    if (sign == [self seletedDNAssetArray].count) {
                        [imagePicker.imagePickerDelegate neImagePickerController:imagePicker images:imagesArray isFullImage:self.isFullImage];
                    }
                } failureBlock:^(NSError *error){
                    
                }];
            }
        }
    }
#pragma clang diagnostic pop
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)browserPhotoAsstes:(NSArray *)assets pageIndex:(NSInteger)page
{
    NEPhotoBrowser *browser = [[NEPhotoBrowser alloc] initWithPhotos:assets
                                                        currentIndex:page
                                                           fullImage:self.isFullImage];
    [browser.sendButton setTitleText:self.confirmText];
    [browser.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    browser.delegate = self;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (BOOL)seletedAssets:(ALAsset *)asset
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Select a maximum of 9 photos", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }else
    {
        [self addAssetsObject:asset];
        self.sendButton.badgeValue = [NSString stringWithFormat:@"%@",@(self.selectedAssetsArray.count)];
        return YES;
    }
}

- (void)deseletedAssets:(ALAsset *)asset
{
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
- (ALAssetsLibrary *)assetsLibrary
{
    if (nil == _assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (UICollectionView *)imageFlowCollectionView
{
    if (nil == _imageFlowCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _imageFlowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationController.toolbar.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - 20) collectionViewLayout:layout];
        _imageFlowCollectionView.backgroundColor = [UIColor clearColor];
        [_imageFlowCollectionView registerClass:[NEAssetsViewCell class] forCellWithReuseIdentifier:NEAssetsViewCellReuseIdentifier];
        
        _imageFlowCollectionView.alwaysBounceVertical = YES;
        _imageFlowCollectionView.delegate = self;
        _imageFlowCollectionView.dataSource = self;
        _imageFlowCollectionView.showsHorizontalScrollIndicator = YES;
        [self.view addSubview:_imageFlowCollectionView];
    }
    
    return _imageFlowCollectionView;
}
- (UIButton *)previewButton{
    if (!_previewButton) {
        _previewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 18)];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_previewButton setTitleColor:[UIColor colorWithRed:255 /255. green:89 /255. blue:106 /255. alpha:1] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor colorWithHexString:@"dbdbdb"] forState:UIControlStateDisabled];
    }
    return _previewButton;
}
- (NESendButton *)sendButton
{
    if (nil == _sendButton) {
        _sendButton = [[NESendButton alloc] initWithFrame:CGRectMake(0, 0, 74, 33)];
        [_sendButton addTaget:self action:@selector(sendButtonAction:)];
        [_sendButton setTitleText:self.confirmText];
        [_sendButton setEnabled:[UIColor colorWithRed:255 /255. green:89 /255. blue:106 /255. alpha:1]];
        [_sendButton setDisabledColor:[UIColor colorWithHexString:@"dbdbdb"]];
    }
    return  _sendButton;
}

#pragma mark - ui action
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonAction:(id)sender
{
    if (self.selectedAssetsArray.count > 0) {
        [self sendImages];
    }
}

- (void)previewAction
{
    [self browserPhotoAsstes:self.selectedAssetsArray pageIndex:0];
}

- (void)cancelAction
{
    NEImagePickerController *navController = [self NEImagePickerController];
    if (navController && [navController.imagePickerDelegate respondsToSelector:@selector(neImagePickerControllerDidCancel:)]) {
        [navController.imagePickerDelegate neImagePickerControllerDidCancel:navController];
    }
}

#pragma mark - NEAssetsViewCellDelegate
- (void)didSelectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell
{
    assetsCell.isSelected = [self seletedAssets:assetsCell.asset];
}

- (void)didDeselectItemAssetsViewCell:(NEAssetsViewCell *)assetsCell
{
    assetsCell.isSelected = NO;
    [self deseletedAssets:assetsCell.asset];
}

#pragma mark - UICollectionView delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NEAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NEAssetsViewCellReuseIdentifier forIndexPath:indexPath];
    ALAsset *asset = self.assetsArray[indexPath.row];
    cell.delegate = self;
    [cell fillWithAsset:asset isSelected:[self assetIsSelected:asset]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self browserPhotoAsstes:self.assetsArray pageIndex:indexPath.row];
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - NEPhotoBrowserDelegate
- (void)sendImagesFromPhotobrowser:(NEPhotoBrowser *)photoBrowser currentAsset:(ALAsset *)asset
{
    if (self.selectedAssetsArray.count <= 0) {
        [self seletedAssets:asset];
        [self.imageFlowCollectionView reloadData];
    }
    [self sendImages];
}

- (NSUInteger)seletedPhotosNumberInPhotoBrowser:(NEPhotoBrowser *)photoBrowser
{
    return self.selectedAssetsArray.count;
}

- (BOOL)photoBrowser:(NEPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(ALAsset *)asset{
    return [self assetIsSelected:asset];
}

- (BOOL)photoBrowser:(NEPhotoBrowser *)photoBrowser seletedAsset:(ALAsset *)asset
{
    BOOL seleted = [self seletedAssets:asset];
    [self.imageFlowCollectionView reloadData];
    return seleted;
}

- (void)photoBrowser:(NEPhotoBrowser *)photoBrowser deseletedAsset:(ALAsset *)asset
{
    [self deseletedAssets:asset];
    [self.imageFlowCollectionView reloadData];
}

- (void)photoBrowser:(NEPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage
{
    self.isFullImage = fullImage;
}

- (void)dealloc{

}

#pragma mark -- getter
- (NSUInteger)limiteCount{
    if (!_limiteCount) {
        _limiteCount = 9;
    }
    return _limiteCount;
}
@end
