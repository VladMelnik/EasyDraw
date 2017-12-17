#import "InstructionViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


//static NSString* const bannerViewId         = @"ca-app-pub-8976158106035977/1485612047";
static NSString* const bannerViewId         = @"ca-app-pub-6503742939423863/3107784422";

@interface InstructionViewController ()

@property (strong, nonatomic) NSArray* lessonData;
@property (strong, nonatomic) NSDictionary* currentLesson;

@property (assign, nonatomic) NSInteger possition;
@property (assign, nonatomic) NSInteger maxSteps;


@property(nonatomic, strong) GADBannerView *bannerView;
@property (strong, nonatomic) GADRequest* request;

@property (strong, nonatomic) NSString* pathToLessonFolder;
@end

BOOL isBannerVisible = NO;


@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _lessonData = [self parseLessonsFromXMLFileWithName:XMLParserListDataNameKey];
    _currentLesson = [self lessonFromArray:_lessonData withNumber:_indexPath.row];
    _possition = 0;
    
    
    
    _image.image = [self getImage];
    
    NSString* stepsString = [_currentLesson valueForKey:lessonDataStepsKey];
    _maxSteps = stepsString.integerValue;
    _stepsCount.text = [NSString stringWithFormat:@"0/%@",stepsString];
    
    
    
    
    
    CGRect imageRect = _image.frame;
    imageRect.size.height = self.rightButton.frame.origin.y;
    _image.frame = imageRect;
    
    _leftButton.hidden = YES;
    
    _bannerView.delegate = self;
    
    
    _request = [GADRequest request];


    
    


}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _lessonData = [self parseLessonsFromXMLFileWithName:XMLParserListDataNameKey];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    isBannerVisible = NO;
}


#pragma mark - Buttons

- (IBAction)rightButtonClicked:(id)sender {
    if (_possition >= 0 && _possition < _maxSteps){
        ++_possition;
        _stepsCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)_possition, (long)_maxSteps];
        
        [UIView transitionWithView:self.view
                          duration:0.6f
                           options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveLinear
                        animations:^{
                            _image.image = [self getImage];
                        } completion:NULL];
        
        
        if (_possition == _maxSteps){
            _rightButton.hidden = YES;
        }else{
            _leftButton.hidden  = NO;
            _rightButton.hidden = NO;
        }
        
        
        //---- Banner
        self.bannerView = [[GADBannerView alloc]
                           initWithAdSize:kGADAdSizeSmartBannerPortrait];

        CGRect bannerRect = self.bannerView.frame;
        bannerRect.origin.y = self.view.bounds.size.height - bannerRect.size.height;
        bannerRect.size.width = self.view.bounds.size.width;
        self.bannerView.frame = bannerRect;

        [self.view addSubview:self.bannerView];
        self.bannerView.adUnitID = bannerViewId;
        self.bannerView.rootViewController = self;

        [self.bannerView loadRequest:_request];
        
        if (!isBannerVisible){
            CGRect rect = _leftButton.frame;
            rect.origin.y = _bannerView.frame.origin.y - rect.size.height - 10;
            _leftButton.frame = rect;
            
            rect = _rightButton.frame;
            rect.origin.y = _bannerView.frame.origin.y - rect.size.height - 10;
            _rightButton.frame = rect;
            
            rect = _stepsCount.frame;
            rect.origin.y = CGRectGetMidY(_rightButton.frame) - rect.size.height/2;
            
            _stepsCount.frame = rect;
            
            
            rect = _image.frame;
            rect.size.height = _rightButton.frame.origin.y - self.navigationController.navigationBar.frame.size.height  - 10;
            _image.frame = rect;
            
            isBannerVisible = YES;
        }
        
        ///-------
        
        
        
    }
   
    
}

- (IBAction)leftButtonClicked:(id)sender {
    if (_possition > 0 && _possition <= _maxSteps){
        --_possition;
        
        [UIView transitionWithView:self.view
                          duration:0.6f
                           options:UIViewAnimationOptionTransitionCurlDown | UIViewAnimationOptionCurveLinear
                        animations:^{
                            _image.image = [self getImage];
                        } completion:NULL];
        
        
        _stepsCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)_possition, (long)_maxSteps];
        
        if (_possition == 0){
            _leftButton.hidden = YES;
        }else{
            _leftButton.hidden  = NO;
            _rightButton.hidden = NO;
        }
    }
}

#pragma mark - Get Image Method

- (UIImage*) getImage{
    NSString* identifier = [_currentLesson valueForKey:lessonDataIdKey];
    _pathToLessonFolder = [self pathToLessonWithNumber:[self changeNumber:identifier.integerValue]];
   
    
    
    NSString* pathToImage = [_pathToLessonFolder
                             stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"step_%@",[self changeNumber:_possition]]];
    
    
    UIImage* image = [UIImage imageWithContentsOfFile:pathToImage];
    return image;
}


#pragma mark - Banner Delegate


- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Banner Error: %@", error.userInfo);
}

@end
