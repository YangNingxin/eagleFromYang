//
//  OrganizationViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseModel.h"
#import "CourseCell.h"
#import "NGWebView.h"

@interface OrganizationViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSOperation *_newRequest;
    int _newPage;
    int _pageNum;
}

@property (nonatomic, strong) CourseModel *courseModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NGWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *staueImageView;

/**
 *  机构详情页URL
 */
@property (nonatomic, strong) NSString *url;

/**
 *  课程id
 */
@property (nonatomic) int organizationId;

/**
 *  机构名字
 */
@property (nonatomic, strong) NSString *name;

@property (nonatomic) BOOL is_follow;

@end
