//
//  NearOrganController.m
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NearOrganController.h"
#import "OrganCell.h"
#import "OrganizationViewController.h"
#import "Location.h"
#import "SearchOrganViewController.h"
#import "OrganAnnotView.h"

@interface NearOrganController ()
{
    UIButton *_searchButton;
}
@end

@implementation NearOrganController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShowList = YES;
    _page = 1;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrganCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    
    self.searchBar.placeholder = @"搜索";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:LOCATION_MANAGER_SUCCESS object:nil];

    [[Location shareManager] initLocationManager];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mapView.hidden = YES;
    _mapView.zoomLevel = 15;
    [self.view addSubview:_mapView];
    
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 40)];
    _searchButton.backgroundColor = [UIColor whiteColor];
    [_searchButton setContentMode:UIViewContentModeCenter];
    [_searchButton setImage:[UIImage imageNamed:@"searh_button"] forState:UIControlStateNormal];
    [_searchButton setImage:[UIImage imageNamed:@"searh_button"] forState:UIControlStateHighlighted];
    _searchButton.hidden = YES;
    [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [_searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)appWillEnterForegroundNotification {
    
    if ([Location shareManager].location.latitude == 0 && [Location shareManager].location.longitude == 0) {
        [[Location shareManager] initLocationManager];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    _mapView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}

- (void)locationSuccess {
    [self getDataFromServer];
    
    [_mapView setCenterCoordinate:[Location shareManager].location animated:YES];
    [[Location shareManager] stopLocationManager];
}

- (void)getDataFromServer {
    
    [_request cancel];
    _request = nil;
    
    float lat = [Location shareManager].location.latitude;
    float lon = [Location shareManager].location.longitude;
    
    _request = [DataHelper getOrganizationList:@"" lat:lat lon:lon page:_page page_num:-1 success:^(id responseObject) {
        self.organListModel = responseObject;
        [self.tableView reloadData];
        [self addAnnotView];
    } fail:^(NSError *error) {
        
    }];
}

- (void)configBaseUI {
    
    [super configBaseUI];
    _titleLabel.text = @"附近机构";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    
    [_rightButotn setTitle:@"地图" forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    if (_isShowList) {
        [_rightButotn setTitle:@"列表" forState:UIControlStateNormal];
        _mapView.hidden = NO;
        _searchButton.hidden = NO;
        _tableView.hidden = YES;
        
    } else {
        [_rightButotn setTitle:@"地图" forState:UIControlStateNormal];
        _mapView.hidden = YES;
        _searchButton.hidden = YES;
        _tableView.hidden = NO;
    }
    _isShowList = !_isShowList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加标注
- (void)addAnnotView {
    
    for (Organ *organ in self.organListModel.data) {
        
       OrganPointAnnot *pointAnnotation = [[OrganPointAnnot alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [organ.latitude floatValue];
        coor.longitude = [organ.longitude floatValue];
        
        pointAnnotation.organ = organ;
        pointAnnotation.title = @"";
        pointAnnotation.coordinate = coor;
        [_mapView addAnnotation:pointAnnotation];
    }
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.organListModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrganCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Organ *organ = self.organListModel.data[indexPath.row];
    cell.organ = organ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Organ *organ = self.organListModel.data[indexPath.row];
    [self gotoOrganizationViewController:organ];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    SearchOrganViewController *searchVc = [[SearchOrganViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)searchButtonAction {
    SearchOrganViewController *searchVc = [[SearchOrganViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark
#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        OrganView *organView = [[OrganView alloc] initWithFrame:CGRectMake(0, 0, 156, 75)];
        organView.tag = 100;
        BMKActionPaopaoView *paoView = [[BMKActionPaopaoView alloc] initWithCustomView:organView];
        annotationView.paopaoView = paoView;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:organView.bounds];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [organView addSubview:button];
    }
    
    OrganView *view = (OrganView *)[annotationView.paopaoView viewWithTag:100];
    OrganPointAnnot *organPoint = (OrganPointAnnot *)annotation;
    view.organ = organPoint.organ;
    
    return annotationView;
}

// 进入机构详情页
- (void)gotoOrganizationViewController:(Organ *)organ {
    
    OrganizationViewController *organizationVc = [[OrganizationViewController alloc] init];
    organizationVc.url = organ.url;
    organizationVc.name = organ.name;
    organizationVc.is_follow = organ.is_follow;
    organizationVc.organizationId = [organ.oid intValue];
    [self.navigationController pushViewController:organizationVc animated:YES];

}

- (void)nextAction:(UIButton *)tap {
    
    OrganView *view = (OrganView *)[tap superview];
    [self gotoOrganizationViewController:view.organ];
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
