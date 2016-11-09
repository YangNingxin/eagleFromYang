//
//  LocationViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface BdLocationViewController : BaseViewController<UIActionSheetDelegate, BMKMapViewDelegate>
{
    BMKMapView* _mapView;
    
    NSMutableArray *_mapsUrlArray;
    UIActionSheet *_actionSheet;
    
    CLLocationCoordinate2D current;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D cooridinate;
@end
