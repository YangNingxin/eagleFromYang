//
//  LocationViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BdLocationViewController.h"
#import "AppDelegate.h"
#import "Location.h"

@interface BdLocationViewController ()

@end

@implementation BdLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:_mapView];
    
    [_mapView setCenterCoordinate:self.cooridinate animated:YES];
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 19;
    
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = self.cooridinate;
    annotation.title = self.name;
    [_mapView addAnnotation:annotation];
    
    // 添加定位观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:LOCATION_MANAGER_SUCCESS object:nil];
    [self startLocation];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  开始定位
 */
- (void)startLocation
{
    _rightButotn.enabled = NO;
    [[Location shareManager] initLocationManager];
}

/**
 *  定位成功
 */
- (void)locationSuccess {
    
    _rightButotn.enabled = YES;
    current = [Location shareManager].location;
    [[Location shareManager] stopLocationManager];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

- (void)rightButtonAction {
    [self openOtherMap];
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
                       current.latitude,
                       current.longitude,
                       self.cooridinate.latitude,
                       self.cooridinate.longitude];
        [_mapsUrlArray addObject:str];
    }
    NSURL * baidu_App = [NSURL URLWithString:@"baidumap://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:baidu_App]) {
        [mapsArray addObject:@"百度地图"];
    
        
        NSString *str=[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=companyName|appName",
                       current.latitude,
                       current.longitude,
                       self.cooridinate.latitude,
                       self.cooridinate.longitude];
        
        
        [_mapsUrlArray addObject:str];
    }
    NSURL * gaode_App = [NSURL URLWithString:@"iosamap://"];
    if ([[UIApplication sharedApplication] canOpenURL:gaode_App]) {
        [mapsArray addObject:@"高德地图"];
        
        NSString *str=[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&backScheme=applicationScheme&slat=%f&slon=%f&sname=我&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=1",current.latitude,
                       current.longitude,
                       self.cooridinate.latitude,
                       self.cooridinate.longitude,
                       self.name];
        
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

#pragma mark
#pragma mark MapViewDelegate

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _titleLabel.text = @"上课地点";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"导航" forState:UIControlStateNormal];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
