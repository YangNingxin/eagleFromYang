//
//  ChoicePlaceViewController.m
//  NGEagle
//
//  Created by zhaoxiaolu on 16/5/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ChoicePlaceViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMKSearchComponent.h>
#import <BaiduMapAPI/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface ChoicePlaceViewController () <BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, UISearchBarDelegate>

@end

@implementation ChoicePlaceViewController {
    BMKMapView *mapView;
    BMKPoiSearch *_searcher;
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
    
    UISearchBar *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = @"选择群地点";
    [self initMapView];
    [self initLocationService];
    [self createSearchView];
    [self getSearch];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mapView viewWillAppear];
    _searcher.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mapView viewWillDisappear];
    mapView.delegate = nil;
    _searcher.delegate = nil;
    _locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark === BMKMapViewDelegate 地图 ===
#pragma mark -

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"map view: did finish");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

#pragma mark -
#pragma mark === BMKLocationServiceDelegate 地图定位 ===
#pragma mark -

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
    [mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [mapView updateLocationData:userLocation];
    _userLocation = userLocation;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

// 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {
    
}

#pragma mark -
#pragma mark === BMKPoiSearchDelegate 地图搜索 ===
#pragma mark -

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            NSLog(@"位置为:%@", poi.name);
            
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark -
#pragma mark === UISearchBarDelegate 搜索栏 ===
#pragma mark -

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}


#pragma mark - private methods

- (void)initMapView {
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)initLocationService {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];
    mapView.showsUserLocation = YES;
}

- (void)createSearchView {
    // 搜索条
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, 44.f)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入名字快速查找";
    [self.view addSubview:_searchBar];
}

- (void)getSearch {
    _searcher = [[BMKPoiSearch alloc]init];
    //发起检索
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.city = @"北京";
    option.keyword = @"小吃";
    BOOL flag = [_searcher poiSearchInCity:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}


@end
