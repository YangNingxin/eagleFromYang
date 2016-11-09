//
//  NearOrganController.h
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrganListModel.h"
#import <BaiduMapAPI/BMapKit.h>

@interface NearOrganController : BaseViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,BMKMapViewDelegate>
{
    BMKMapView* _mapView;
    NSOperation *_request;
    int _page;
    BOOL _isShowList;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) OrganListModel *organListModel;

- (void)getDataFromServer;

@end
