/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "LocationViewController.h"
#import "UIViewController+HUD.h"
#import "Location.h"

@interface LocationViewController () {
    BMKMapView* _mapView;

    NSMutableArray *_mapsUrlArray;
    UIActionSheet *_actionSheet;
    
    /**
     *  用户位置信息
     */
    CLLocationCoordinate2D _userLocationCoordinate;
    
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
}

@property (strong, nonatomic) NSString *addressString;

@end

@implementation LocationViewController

@synthesize addressString = _addressString;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"位置信息";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 19;
    

    // 添加定位观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:LOCATION_MANAGER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFail) name:LOCATION_MANAGER_FAIL object:nil];
    [self startLocation];

    if (_isSendLocation) {

        [_rightButotn setTitle:@"发送" forState:UIControlStateNormal];
        
    } else {
        
        [_rightButotn setTitle:@"导航" forState:UIControlStateNormal];
        [self addLocation:_currentLocationCoordinate];
    }
}

/**
 *  定位成功
 */
- (void)locationSuccess {

    _rightButotn.enabled = YES;
    _userLocationCoordinate = [Location shareManager].location;
    [[Location shareManager] stopLocationManager];
    
    if (_isSendLocation) {
        [self addLocation:_userLocationCoordinate];
    }

    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[Location shareManager].userLocation completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            weakSelf.addressString = placemark.name;
            
        }
    }];
}

/**
 *  定位失败
 */
- (void)locationFail {
    [self hideHud];
}

- (void)rightButtonAction {
    
    if (_isSendLocation) {
        [self sendLocation];
    } else {
        [self openOtherMap];
    }
}

-(void)openOtherMap{
    
    _actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    NSMutableArray *mapsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _mapsUrlArray = [[NSMutableArray alloc] init];
    
    NSURL *apple_App = [NSURL URLWithString:@"http://maps.apple.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:apple_App]) {
        [mapsArray addObject:@"苹果地图"];
        
        NSString *str=[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f",
                       _userLocationCoordinate.latitude,
                       _userLocationCoordinate.longitude,
                       _currentLocationCoordinate.latitude,
                       _currentLocationCoordinate.longitude];
        [_mapsUrlArray addObject:str];
    }
    NSURL * baidu_App = [NSURL URLWithString:@"baidumap://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:baidu_App]) {
        [mapsArray addObject:@"百度地图"];
        
        
        NSString *str=[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=companyName|appName",
                       _userLocationCoordinate.latitude,
                       _userLocationCoordinate.longitude,
                       _currentLocationCoordinate.latitude,
                       _currentLocationCoordinate.longitude];
        
        
        [_mapsUrlArray addObject:str];
    }
    NSURL * gaode_App = [NSURL URLWithString:@"iosamap://"];
    if ([[UIApplication sharedApplication] canOpenURL:gaode_App]) {
        [mapsArray addObject:@"高德地图"];
        
        NSString *str=[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&backScheme=applicationScheme&slat=%f&slon=%f&sname=我&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=1",
                       _userLocationCoordinate.latitude,
                       _userLocationCoordinate.longitude,
                       _currentLocationCoordinate.latitude,
                       _currentLocationCoordinate.longitude,
                       @""];
        
        [_mapsUrlArray addObject:str];
    }
    
    for (int x=0; x<mapsArray.count; x++) {
        [_actionSheet addButtonWithTitle:[mapsArray objectAtIndex:x]];
    }
    
    [_actionSheet addButtonWithTitle:@"取消"];
    
    // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮
    // NB - 这会导致该按钮显示时有黑色背景
    _actionSheet.cancelButtonIndex = _actionSheet.numberOfButtons - 1;
    [_actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    } else {
        
        NSString *str=[_mapsUrlArray objectAtIndex:buttonIndex];
        str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * myURL_APP_A =[[NSURL alloc] initWithString:str];
        NSLog(@"%@",myURL_APP_A);
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            
            [[UIApplication sharedApplication] openURL:myURL_APP_A];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}


- (void)startLocation
{
    _rightButotn.enabled = NO;
    [[Location shareManager] initLocationManager];
    [self showHudInView:self.view hint:@"正在定位..."];
}

- (void)addLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [self hideHud];
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = locationCoordinate;
//    annotation.title = self.name;
    [_mapView addAnnotation:annotation];
    
    [_mapView setCenterCoordinate:locationCoordinate animated:YES];
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}


- (void)sendLocation
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [_delegate sendLocationLatitude:_userLocationCoordinate.latitude longitude:_userLocationCoordinate.longitude andAddress:_addressString];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
