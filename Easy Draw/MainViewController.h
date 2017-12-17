#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>






@interface MainViewController : ViewController <UITableViewDelegate, UITableViewDataSource , GADRewardBasedVideoAdDelegate, GADBannerViewDelegate, GADInterstitialDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
