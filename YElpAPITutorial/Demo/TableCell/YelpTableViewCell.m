//
//  YelpTableViewCell.m
//  GebeChat
//
//  Created by Siba Prasad Hota on 12/01/15.
//  Copyright (c) 2015 WemakeAppz. All rights reserved.
//

#import "YelpTableViewCell.h"

#import "AsyncImageView.h"

@implementation YelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(YelpListing*)rmodel
{
    self.restaurantName.text=rmodel.name;
    self.restaurantAddress.text=[rmodel.display_address description];
    if(rmodel.image_url)
    self.rest_ImageView.imageURL=[NSURL URLWithString:rmodel.image_url];
    self.rating_ImageView.imageURL=[NSURL URLWithString:rmodel.rating_img_url_large];
    self.phoneLabel.text=[NSString stringWithFormat:@"Ph: %@",rmodel.display_phone];
    self.review_countlabel.text=[NSString stringWithFormat:@"Reviewed by %@users",rmodel.review_count];
    //review_count
}

@end
