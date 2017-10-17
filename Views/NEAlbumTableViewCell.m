//
//  NEAlbumTableViewCell.m
//  MeMe
//
//  Created by Chang Liu on 9/5/17.
//  Copyright © 2017 sip. All rights reserved.
//

#import "NEAlbumTableViewCell.h"

@implementation NEAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size.width = imageFrame.size.height;
    [self.imageView setFrame:imageFrame];
    [self.imageView.layer setMasksToBounds:YES];
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(imageFrame) + 10;
    [self.textLabel setFrame:labelFrame];
}
@end
