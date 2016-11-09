//
//  NearCourseViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NearCourseViewController.h"
#import "Location.h"
#import "NearCourseCell.h"
#import "CourseAnnotView.h"
#import "SearchCourseViewController.h"
#import "CourseDetailViewController.h"

@interface NearCourseViewController ()

@end

@implementation NearCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NearCourseCell" bundle:nil]
         forCellReuseIdentifier:@"NearCourseCell"];
    
    [self getDataFromServer];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    
    [super configBaseUI];
    _titleLabel.text = @"附近课程";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    
}

- (void)getDataFromServer {
    
    [_request cancel];
    _request = nil;
    
    float lat = [Location shareManager].location.latitude;
    float lon = [Location shareManager].location.longitude;
    
    _request = [DataHelper getNearbyCourseList:lat lon:lon range:10 page:_page page_num:-1 success:^(id responseObject) {
        
        self.courseModel = responseObject;
        [self.tableView reloadData];
        [self addAnnotView];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)addAnnotView {
    
    for (Course *course in self.courseModel.data) {
        
        CoursePointAnnot *pointAnnotation = [[CoursePointAnnot alloc] init];
        
        CLLocationCoordinate2D coor;
        coor.latitude = [course.latitude floatValue];
        coor.longitude = [course.longitude floatValue];
        
        pointAnnotation.course = course;
        pointAnnotation.title = @"";
        pointAnnotation.coordinate = coor;
        [_mapView addAnnotation:pointAnnotation];
    }
}
    
#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearCourseCell" forIndexPath:indexPath];
    
    Course *course = self.courseModel.data[indexPath.row];
    cell.course = course;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = self.courseModel.data[indexPath.row];
    [self gotoCourseDetailViewController:course];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    SearchCourseViewController *searchVc = [[SearchCourseViewController alloc] initWithNibName:@"SearchCourseViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)searchButtonAction {
    
    SearchCourseViewController *searchVc = [[SearchCourseViewController alloc] initWithNibName:@"SearchCourseViewController" bundle:nil];
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark
#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        CourseView *organView = [[CourseView alloc] initWithFrame:CGRectMake(0, 0, 156, 75)];
        organView.tag = 100;
        BMKActionPaopaoView *paoView = [[BMKActionPaopaoView alloc] initWithCustomView:organView];
        annotationView.paopaoView = paoView;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:organView.bounds];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [organView addSubview:button];
    }
    
    CourseView *view = (CourseView *)[annotationView.paopaoView viewWithTag:100];
    CoursePointAnnot *organPoint = (CoursePointAnnot *)annotation;
    view.course = organPoint.course;
    
    
    return annotationView;
}


- (void)gotoCourseDetailViewController:(Course *)course {
        
    CourseDetailViewController *webVc = [[CourseDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];

    webVc.webTitle = @"课程详情";
    webVc.url = course.url;
    webVc.webType = COURSE_DETAIL;
    webVc.cid = [course.cid intValue];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)nextAction:(UIButton *)tap {
    CourseView *view = (CourseView *)[tap superview];
    [self gotoCourseDetailViewController:view.course];
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
