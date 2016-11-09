//
//  Location.m
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "Location.h"



static Location *share = nil;

@implementation Location

+ (Location *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Location alloc] init];
    });
    return share;
}

#pragma mark
#pragma mark LocationManager

// 初始化定位
- (void)initLocationManager
{
    if(!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert;
        if (IOS8)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"定位功能不可用" message:LOCATION_FAILURE delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        }
        else
        {
            alert = [[UIAlertView alloc]initWithTitle:@"定位功能不可用" message:LOCATION_FAILURE delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
        alert.tag = 909;
        [alert show];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_NOT_ALLOWED object:nil];
        
    }else{
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        if (IOS8) {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }
}
//停止定位服务
- (void)stopLocationManager
{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
    _locationManager.delegate = nil;
    _locationManager = nil;
}

#pragma mark --- locationManager - Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    self.userLocation = (CLLocation *)[locations lastObject];
    // 定位成功，存储下来
    self.location = self.userLocation.coordinate;
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_MANAGER_SUCCESS object:nil];
    NSLog(@"locations : %@",locations);
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    _locationManager = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_MANAGER_FAIL object:nil];
    
    //这种限于，用户飞行模式，即时打开定位，也获取不到位置坐标
    UIAlertView *alert;
    if (IOS8)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"定位功能不可用" message:LOCATION_FAILURE delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle:@"定位功能不可用" message:@"定位失败，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    
    alert.tag = 909;
    [alert show];
    
}

@end
