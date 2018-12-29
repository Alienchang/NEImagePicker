//
//  NEAlbumTableViewController.m
//  ImagePicker
//
//  Created by MeMe on 9/5/17.
//  Copyright (c) 2017年 MeMe. All rights reserved.
//

#import "NEAlbumTableViewController.h"
#import "NEImagePickerController.h"
#import "NEImageFlowViewController.h"
#import "UIViewController+NEImagePicker.h"
#import "NEUnAuthorizedTipsView.h"
#import "NEAlbumTableViewCell.h"
#import "NEImageHelper.h"
#import "NEAlbum.h"
static NSString* const NEalbumTableViewCellReuseIdentifier = @"NEalbumTableViewCellReuseIdentifier";

@interface NEAlbumTableViewController ()

#pragma mark - dataSources

@property (nonatomic ,strong) NSMutableArray <NEAlbum *>*albums;

@end

@implementation NEAlbumTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - mark setup Data and View
- (void)loadData {
    __weak typeof(self) weakself = self;
    [self.albums removeAllObjects];
    [NEImageHelper getAlbumList:^(NSArray<NEAlbum *> *albums) {
        [weakself.albums addObjectsFromArray:albums];
        [weakself.tableView reloadData];
    } includeEmpty:NO];
}

- (void)setupData {
    self.albums  = [NSMutableArray new];
}

- (void)setupView {
    self.title = NSLocalizedString(@"Photo", "");
    [self createBarButtonItemAtPosition:NEImagePickerNavigationBarPositionRight
                                   text:NSLocalizedString(@"Cancel", "")
                                 action:@selector(cancelAction:)];
    
    [self.tableView registerClass:[NEAlbumTableViewCell class] forCellReuseIdentifier:NEalbumTableViewCellReuseIdentifier];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
}


#pragma mark - ui actions
- (void)cancelAction:(id)sender {
    NEImagePickerController *navController = [self NEImagePickerController];
    if (navController && [navController.imagePickerDelegate respondsToSelector:@selector(neImagePickerControllerDidCancel:)]) {
        [navController.imagePickerDelegate neImagePickerControllerDidCancel:navController];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [NSMutableArray new];
    }
    return _albums;
}

- (NEImagePickerController *)NEImagePickerController {
    
    if (nil == self.navigationController
        ||
        ![self.navigationController isKindOfClass:[NEImagePickerController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (NEImagePickerController *)self.navigationController;
}

- (NSAttributedString *)albumTitle:(NEAlbum *)album {
    NSString *albumTitle = album.albumTitle;
    NSString *numberString = [NSString stringWithFormat:@"  (%@)",@(album.imagesCout)];
    NSString *cellTitleString = [NSString stringWithFormat:@"%@%@",albumTitle,numberString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cellTitleString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:18],
                                       NSForegroundColorAttributeName : [UIColor colorWithRed:60 /255. green:60 /255. blue:60 /255. alpha:1],
                                       }
                              range:NSMakeRange(0, albumTitle.length)];
    return attributedString;
}

- (void)showUnAuthorizedTipsView {
    NEUnAuthorizedTipsView *view  = [[NEUnAuthorizedTipsView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView = view;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NEAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NEalbumTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NEAlbum *album = self.albums[indexPath.row];
    cell.textLabel.attributedText = [self albumTitle:album];
    [cell.imageView setImage:album.albumImage];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NEImageFlowViewController *imageFlowViewController = [[NEImageFlowViewController alloc] initWithAlbum:self.albums[indexPath.row]];
    [imageFlowViewController setLimiteCount:self.limiteCount];
    [imageFlowViewController setConfirmText:self.confirmText];
    [self.navigationController pushViewController:imageFlowViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
