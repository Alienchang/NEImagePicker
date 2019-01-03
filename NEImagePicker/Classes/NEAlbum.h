//
//  NEAlbum.h
//  NESocialClient
//
//  Created by Chang Liu on 11/21/17.
//  Copyright © 2017 Next Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEAsset.h"

@interface NEAlbum : NSObject
@property (nonatomic ,strong) UIImage   *albumImage;
@property (nonatomic ,assign) NSInteger assetID;
@property (nonatomic ,strong) NSString  *albumTitle;
@property (nonatomic ,assign) NSInteger imagesCout;
@property (nonatomic ,copy)   NSString  *localIdentifier;      //PHAssetCollection localIdentifier

- (void)fetchAlbumImage:(void(^)(UIImage *image))complete;
- (void)fetchAssets:(void(^)(NSArray <NEAsset *>* assets))complete;

//返回没有包含Image的asset
- (void)fetchAssetsWithoutImage:(void (^)(NSArray<NEAsset *>*assets))complete;
@end
