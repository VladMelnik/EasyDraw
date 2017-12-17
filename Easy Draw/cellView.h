#import <UIKit/UIKit.h>

@interface cellView : UIView

@property (nonatomic, retain) IBOutlet UIView *myViewFromNib;



@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *steps;
@property (strong, nonatomic) IBOutlet UIImageView *rate;
@property (strong, nonatomic) IBOutlet UILabel *difficult;
@property (strong, nonatomic) IBOutlet UIImageView *lockView;

@end
