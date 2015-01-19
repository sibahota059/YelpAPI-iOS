//
//  YelpTableViewCell.h
//  GebeChat
//
//  Created by Siba Prasad Hota on 12/01/15.
//  Copyright (c) 2015 WemakeAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpListing.h"

@interface YelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UIImageView *rest_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rating_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *review_countlabel;

-(void)setCellData:(YelpListing*)rmodel;

@end
