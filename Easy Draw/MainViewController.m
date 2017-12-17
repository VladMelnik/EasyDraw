#import "MainViewController.h"
#import "cellView.h"
#import "InstructionViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

// ca-app-pub-8976158106035977/5915811646

//static NSString* const bannerViewId         = @"ca-app-pub-8976158106035977/1485612047";
//static NSString* const interstitialViewId   = @"ca-app-pub-8976158106035977/2962345243";
//static NSString* const rewardVideoViewId    = @"ca-app-pub-8976158106035977/5915811646";

static NSString* const bannerViewId         = @"ca-app-pub-6503742939423863/3107784422";
static NSString* const interstitialViewId   = @"ca-app-pub-6503742939423863/4037722710";
static NSString* const rewardVideoViewId    = @"ca-app-pub-6503742939423863/8102705205";

BOOL isMessagePresentationOn = YES;

@interface MainViewController ()
@property(nonatomic, strong) GADInterstitial *interstitial;



@property (strong, nonatomic) NSMutableArray* lessonData;
@property (strong, nonatomic) NSMutableDictionary* lockDictionary;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
@property(nonatomic, strong) GADBannerView *bannerView;

@property (strong, nonatomic) GADRequest* request;


@end

BOOL isRewardVideoSuccesful = NO;


@implementation MainViewController


#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    // SET BackGround for UITableView
    UIImage* backgroundImage = [UIImage imageNamed:@"main-view-background"];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImageView setImage:backgroundImage];
    [_tableView setBackgroundView:backgroundImageView];
    

    
    //     Google AdMob Setup
    _request = [GADRequest request];

    
    
//    ---- Banner
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;

    CGRect bannerRect = self.bannerView.frame;
    bannerRect.origin.y = self.view.bounds.size.height - bannerRect.size.height;
    bannerRect.size.width = self.view.bounds.size.width;
    self.bannerView.frame = bannerRect;

    [self.view addSubview:self.bannerView];

    self.bannerView.adUnitID = bannerViewId;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:_request];
    ///-------

     [GADRewardBasedVideoAd sharedInstance].delegate = self;



    _interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:interstitialViewId];
    _interstitial.delegate = self;
    

    CGRect tableViewRect = _tableView.frame;
    tableViewRect.size.height = bannerRect.origin.y;
    _tableView.frame = tableViewRect;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _lessonData = [self parseLessonsFromXMLFileWithName:XMLParserListDataNameKey];
    
    NSString* path = [self pathToFileWithName:pathToFileWithLockNameKey];
    NSLog(@"%@", [self pathToFileWithName:pathToFileWithLockNameKey]);
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [self createFileWithPath:path andFileType:FileTypeDictionary];
        _lockDictionary = [self getInformationFromFileWithPath:path andFileClasification:FileTypeDictionary];
        [self fillDataWithArray];
        
    }else{
        _lockDictionary = [self getInformationFromFileWithPath:path andFileClasification:FileTypeDictionary];
    }

    
    [_tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated{
    [_lockDictionary writeToFile:[self pathToFileWithName:pathToFileWithLockNameKey] atomically:YES];
}


#pragma mark - Table View UI
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"cellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cellView* cView;
    
    
    NSDictionary* currentLesson = [self lessonFromArray:_lessonData withNumber:indexPath.row];
    
    
    UIImage* icon = nil;
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cView = [[cellView alloc] initWithFrame:cell.frame];
        
        
    }else{
        NSArray* sub = [cell subviews];
        for (UIView* allView in sub){
            if ([allView isKindOfClass:[cellView class]]){
                cView = (cellView*)allView;
                
            }
        }
    }
    

    
    // UI Settings
    
    cView.name.text          = [currentLesson valueForKey:lessonDataNameKey];
    
    cView.steps.text         = [NSString stringWithFormat:@"%@ steps",
                                [currentLesson valueForKey:lessonDataStepsKey]];
    cView.difficult.text     = [NSString stringWithFormat:@"Сложность: %@",
                                [currentLesson valueForKey:lessonDataRateKey]];
    
    
    NSString* rate = [currentLesson valueForKey:lessonDataRateKey];
    UIImage* rateImage = [UIImage imageNamed:
                          [NSString stringWithFormat:@"rate_%ld",(long)rate.integerValue]];
    [cView.rate setImage:rateImage];
    

    NSString* pathToIcon = [self pathToLessonWithNumber:[self changeNumber:indexPath.row+1]];
    pathToIcon = [pathToIcon stringByAppendingPathComponent:@"icon.png"];
    
    
    icon = [UIImage imageWithContentsOfFile:pathToIcon];
    [cView.icon setImage:icon];
    
    
    if ([[_lockDictionary valueForKey:[currentLesson valueForKey:lessonDataIdKey]] isEqualToString:@"0"]){
        UIImage* image = [UIImage imageNamed:@"lock"];
        [cView.lockView setImage:image];
    }else{
        [cView.lockView setImage:nil];
    }
   
    
    
    // Cell Settings
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:cView.myViewFromNib];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_lessonData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndexPath = indexPath;
    if ([self isCellOpenWithIndexPath:indexPath]){
       [self performSegueWithIdentifier:@"instructionSegue" sender:indexPath];
    }else{
        
        if (isMessagePresentationOn){
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"To open a lesson, please watch the video"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:nil];
            
            UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [[GADRewardBasedVideoAd sharedInstance] loadRequest:_request
                                                                                                        withAdUnitID:rewardVideoViewId];
                                                             }];
            
            [alertController addAction:actionOK];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];

        }else{
            [[GADRewardBasedVideoAd sharedInstance] loadRequest:_request
                                                   withAdUnitID:rewardVideoViewId];
        }
        
        
    }
    
}

#pragma mark - Segue


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InstructionViewController* ins = [segue destinationViewController];
    if ([sender isKindOfClass:[NSIndexPath class]]){
        ins.indexPath = sender;
    }
}

#pragma mark - Fill the array data

- (void) fillDataWithArray{
    for (int i = 0; i < [_lessonData count]; i++) {
        NSString* result;
        if (i < 4)  result = @"1";
        else result = @"0";
        
        [_lockDictionary setValue:result forKey:[[_lessonData objectAtIndex:i] valueForKey:lessonDataIdKey]];
        [_lockDictionary writeToFile:[self pathToFileWithName:pathToFileWithLockNameKey] atomically:YES];
    }
}


#pragma mark - Is Paint Open


- (BOOL) isCellOpenWithIndexPath:(NSIndexPath*) indexPath{

    NSDictionary* currentLesson = [_lessonData objectAtIndex:indexPath.row];
    NSString* identifier = [currentLesson valueForKey:lessonDataIdKey];
    
    NSString* state = [_lockDictionary valueForKey:identifier];
    
    if (state.integerValue){
        return YES;
    }else{
        return NO;
    }

}


#pragma mark - Google

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    
    NSDictionary* currentLesson = [_lessonData objectAtIndex:_currentIndexPath.row];
    NSString* identifier = [currentLesson valueForKey:lessonDataIdKey];
    
    
    
    [_lockDictionary removeObjectForKey:identifier];
    [_lockDictionary setValue:@"1" forKey:identifier];
    [_lockDictionary writeToFile:[self pathToFileWithName:pathToFileWithLockNameKey] atomically:YES];
    
    [_tableView reloadData];
    
    isRewardVideoSuccesful = YES;
    
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd{

    if (isRewardVideoSuccesful){
        [self performSegueWithIdentifier:@"instructionSegue" sender:_currentIndexPath];
        isRewardVideoSuccesful = NO;
    }
}


// When Ad is Ready
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {

    if (rewardBasedVideoAd.adNetworkClassName != NULL){
        if ([rewardBasedVideoAd isReady]){
            [rewardBasedVideoAd presentFromRootViewController:self];
        }
    }else{
        NSLog(@"Check your AdID on the correctness!");
        [self.interstitial loadRequest:_request];
    }
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {


    [self.interstitial loadRequest:_request];

    NSLog(@"Reward based video ad failed to load with error: %@", error.userInfo);
}

#pragma mark - Interstitial

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
   _interstitial = [self createAndLoadInterstitial];

    NSDictionary* currentLesson = [_lessonData objectAtIndex:_currentIndexPath.row];
    NSString* identifier = [currentLesson valueForKey:lessonDataIdKey];

    [_lockDictionary removeObjectForKey:identifier];
    [_lockDictionary setValue:@"1" forKey:identifier];
    [_lockDictionary writeToFile:[self pathToFileWithName:pathToFileWithLockNameKey] atomically:YES];


    [self performSegueWithIdentifier:@"instructionSegue" sender:_currentIndexPath];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:interstitialViewId]; // Треба мiнять на inter
    interstitial.delegate = self;
    return interstitial;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [self performSegueWithIdentifier:@"instructionSegue" sender:_currentIndexPath];
    NSLog(@"Interstitial ad failed to load with error: %@", error.userInfo);


}


#pragma mark - Banner Delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    CGRect tableViewRect = _tableView.frame;
    tableViewRect.size.height = self.view.frame.size.height - _bannerView.frame.size.height;
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{

    [UIView animateWithDuration:0.5 animations:^{
        _tableView.frame = self.view.bounds;
    }];

    NSLog(@"Banner Error: %@", error.userInfo);
}


@end
