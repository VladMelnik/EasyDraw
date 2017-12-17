#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface InstructionViewController : ViewController <GADBannerViewDelegate>

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *stepsCount;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;


- (IBAction)rightButtonClicked:(id)sender;
- (IBAction)leftButtonClicked:(id)sender;
@end
