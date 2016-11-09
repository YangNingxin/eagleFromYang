//
//  Location.h
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATION_FAILURE @"为使用此产品功能\n请您为本程序打开【定位服务】"
#define LOCATION_MANAGER_SUCCESS @"locationManagerSuccess"
#define LOCATION_MANAGER_FAIL @"locationManagerFail"
#define LOCATION_NOT_ALLOWED @"locationManagerNotAllow"

@interface Location : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) CLLocation *userLocation;

+ (Location *)shareManager;
- (void)initLocationManager;
- (void)stopLocationManager;

@end
