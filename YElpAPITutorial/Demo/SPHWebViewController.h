//
//  SPHWebViewController.h
//  ChupaChat
//
//  Created by Heart on 26/05/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headeLabel;
- (IBAction)GoBack:(id)sender;

-(IBAction) gowebBack:(id)sender;
-(IBAction) goForward:(id)sender;
- (IBAction)reloAdPage:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *mobileUrl;
@end
