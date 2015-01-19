//
//  YelpListViewController.m
//  GebeChat
//
//  Created by Siba Prasad Hota on 13/01/15.
//  Copyright (c) 2015 WemakeAppz. All rights reserved.
//

#import "YelpListViewController.h"

#import "YELPAPISample.h"
#import <CoreLocation/CoreLocation.h>
#import "YelpListing.h"
#import "YelpTableViewCell.h"
#import "SPHWebViewController.h"
#import "AppDelegate.h"




@interface YelpListViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *SearchedArray;
    NSMutableArray *YelpDataArray;
    BOOL issearchClicked;
    int pagenum;
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *productTable;
@property (weak, nonatomic) IBOutlet UISearchBar *contactsSearchBar;

- (IBAction)searchClicked:(id)sender;

@end

@implementation YelpListViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated
{       //[self showTabBarController];
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}



//*************************************************************

// PUT your API credentials (Secret & key) in YELPAPISample.m

//*************************************************************

- (void)viewDidLoad
{
    issearchClicked=NO;
    
    self.contactsSearchBar.alpha=0.0;
    
    SearchedArray   =[[NSMutableArray alloc]init];
    YelpDataArray   =[[NSMutableArray alloc]init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    // 8:00 AM to 9:00 PM
    pagenum=0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - CLLocationManagerDelegate



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        NSLog(@"longitude=%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"latitude=%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        [self  getRestaurantsByLocation:[NSString stringWithFormat:@"%.8f,%.8f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude] islonglat:YES];
        [locationManager stopUpdatingLocation];
    }
}





-(void)getRestaurantsByLocation:(NSString*)location islonglat:(BOOL)islonglat
{
    if ([location length]<1) return;
    
    YELPAPISample *someApi=[YELPAPISample new];
    [someApi getServerResponseForLocation:location term:@"Restaurant,food" iSLonglat:islonglat withSuccessionBlock:^(NSDictionary *topBusinessJSON)
     {
         NSLog(@"Data From Server is %@",topBusinessJSON);
         
         if (!topBusinessJSON)
         {
             NSLog(@"Response = Not avaialable");
             
             UIAlertView *myAlert=[[UIAlertView alloc]initWithTitle:@"Oops!!" message:@"Sorry! No listings found. Please search another location." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [myAlert show];
         }
         else
         {
             [self separAteParametres:topBusinessJSON];
         }
     } andFailureBlock:^(NSError *error) {
        
    }];
    
   }

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (issearchClicked)
        return 35.0;
    else
        return 150.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (issearchClicked)
        return SearchedArray.count;
    else
        return YelpDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(issearchClicked)
    {
        static NSString *CellIdentifier = @"CountryCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell.textLabel setText:[SearchedArray objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor=[UIColor grayColor];
        return cell;

        
        
    }

    YelpTableViewCell  *cell = (YelpTableViewCell *)[self.productTable dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YelpTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setCellData:[YelpDataArray objectAtIndex:indexPath.row]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.productTable deselectRowAtIndexPath:indexPath animated:YES];
  
    if(issearchClicked)
           self.contactsSearchBar.text=[SearchedArray objectAtIndex:indexPath.row];
    else{
        SPHWebViewController *webview=[[SPHWebViewController alloc]initWithNibName:@"SPHWebViewController" bundle:nil];
        YelpListing *ym=[YelpDataArray objectAtIndex:indexPath.row];
        webview.mobileUrl=ym.mobile_url;
        webview.type=@"Rest_Details";
        [self.navigationController pushViewController:webview animated:YES];
    }
}


-(void)showSearchBar
{
    
    CGRect tableviewframe=self.productTable.frame;
    
    tableviewframe.size.height=self.view.frame.size.height-104;
    tableviewframe.origin.y=104;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contactsSearchBar.alpha=1.0;
        self.productTable.frame=tableviewframe;
    }];
    
    
}
-(void)HideSearchBar
{
    CGRect tableviewframe=self.productTable.frame;
    
    tableviewframe.size.height=self.view.frame.size.height-60;
    tableviewframe.origin.y=60;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contactsSearchBar.alpha=0.0;
        self.productTable.frame=tableviewframe;
    }];
    
    
}



- (IBAction)searchClicked:(id)sender
{
    if (issearchClicked) {
        issearchClicked=NO;
        [self HideSearchBar];
        [self.view endEditing:YES];
    }
    else{
        issearchClicked=YES;
        [self.contactsSearchBar becomeFirstResponder];
        [self showSearchBar];
    }
    [self.productTable reloadData];
    
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    issearchClicked=NO;
    [self HideSearchBar];
    [self.view endEditing:YES];
    [self.productTable reloadData];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    issearchClicked=NO;
    [self HideSearchBar];
    [self.productTable reloadData];
    [self getRestaurantsByLocation:self.contactsSearchBar.text islonglat:NO];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//  if ([searchBar.text length]>0)
//         [self getAreaListFromLocation:self.contactsSearchBar.text];
}



-(void)separAteParametres:(NSDictionary*)params
{
    [YelpDataArray removeAllObjects];
    
    if ([params valueForKey:@"error"])
        return ;
    
    NSArray *businessArray=[params valueForKey:@"businesses"];
    for (NSDictionary *bdict in businessArray)
    {
        YelpListing *yelpModel=[YelpListing new];
        
        yelpModel.restaurant_id=[bdict valueForKey:@"id"];
        yelpModel.is_claimed=[bdict valueForKey:@"is_claimed"];
        yelpModel.is_closed=[bdict valueForKey:@"is_closed"];
        
        NSDictionary *locationDict= [bdict valueForKey:@"location"];
        
        yelpModel.city=[locationDict valueForKey:@"city"];
        yelpModel.address=[locationDict valueForKey:@"address"];
        yelpModel.coordinate=[locationDict valueForKey:@"coordinate"];
        yelpModel.country_code= [locationDict valueForKey:@"country_code"];
        
        NSArray *addressArray=[locationDict valueForKey:@"display_address"];
        
        NSString *final_Address=@"";
        for (NSString *sttring in addressArray){
            final_Address = [NSString stringWithFormat:@"%@, %@",final_Address,sttring];
        }
        
        
        yelpModel.display_address= final_Address;
        yelpModel.geo_accuracy= [locationDict valueForKey:@"geo_accuracy"];
        yelpModel.neighborhoods= [locationDict valueForKey:@"neighborhoods"];
        yelpModel.state_code=[locationDict valueForKey:@"state_code"];
        
        
        yelpModel.mobile_url=[bdict valueForKey:@"mobile_url"];
        yelpModel.name=[bdict valueForKey:@"name"];
        yelpModel.rating=[bdict valueForKey:@"rating"];
        yelpModel.rating_img_url=[bdict valueForKey:@"rating_img_url"];
        yelpModel.rating_img_url_large=[bdict valueForKey:@"rating_img_url_large"];
        yelpModel.rating_img_url_small=[bdict valueForKey:@"rating_img_url_small"];
        yelpModel.url=[bdict valueForKey:@"url"];
        yelpModel.review_count=[bdict valueForKey:@"review_count"];
        yelpModel.display_phone=[bdict valueForKey:@"display_phone"];
        if (!yelpModel.display_phone)
        {
            yelpModel.display_phone=([bdict valueForKey:@"phone"])?[bdict valueForKey:@"phone"]:@"Not updated";
        }
        yelpModel.image_url=[bdict valueForKey:@"image_url"];
        yelpModel.phone=[bdict valueForKey:@"phone"];
        
        yelpModel.snippet_image_url=[bdict valueForKey:@"snippet_image_url"];
        yelpModel.snippet_text=[bdict valueForKey:@"snippet_text"];
        
        
        [YelpDataArray addObject:yelpModel];
    }
   
   
  
    [self.productTable reloadData];

   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
