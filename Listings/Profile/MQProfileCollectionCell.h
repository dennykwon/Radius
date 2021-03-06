//
//  MQProfileCollectionCell.h
//  Listings
//
//  Created by Dan Kwon on 10/29/14.
//  Copyright (c) 2014 Mercury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQProfileCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIView *base;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UILabel *lblName;
@property (strong, nonatomic) UILabel *lblLocation;
@property (strong, nonatomic) UILabel *lblSkills;
@property (strong, nonatomic) UILabel *lblStats;
@end
