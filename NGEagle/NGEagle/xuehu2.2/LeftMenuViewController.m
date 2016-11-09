//
//  LeftMenuViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/5.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "NGTabBarViewController.h"
#import "WTAZoomNavigationController.h"
#import "CCProgressView.h"
#import "SetViewController.h"
#import "MyStudyRecordController.h"
#import "MyTaskViewController.h"
#import "MyQuestionController.h"
#import "MyMarkViewController.h"
#import "TERecommendViewController.h"
#import "TEMyCourseListViewController.h"
#import "PersonPageViewController.h"

@interface LeftMenuViewController ()
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UIImageView *_levelImage;
    UILabel *_levelLabel1;
    CCProgressView *_progressView;
    UILabel *_levelLabel2;
    UILabel *_levelDesc;
    NGTabBarViewController *_tabVc;
}
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Account shareManager].identity == 1) {
        viewControllers = @[
                            @{@"image":@"icon_study_task", @"title":@"我的课程", @"action":@"clickMyCourse"},
                            @{@"image":@"icon_study_record", @"title":@"课程推荐", @"action":@"clickCourseRecommend"},
                            @{@"image":@"icon_my_answer", @"title":@"我的问答", @"action":@"clickMyAnswer"},
                            @{@"image":@"icon_mark", @"title":@"我的收藏", @"action":@"clickMyMark"},
                            @{@"image":@"icon_my_set", @"title":@"个人设置", @"action":@"clickSetting"},];
    } else {
        viewControllers = @[
                            @{@"image":@"icon_study_task", @"title":@"学习任务", @"action":@"clickStudyTask"},
                            @{@"image":@"icon_study_record", @"title":@"学习记录", @"action":@"clickStudyRecord"},
                            @{@"image":@"icon_my_answer", @"title":@"我的问答", @"action":@"clickMyAnswer"},
                            @{@"image":@"icon_mark", @"title":@"我的收藏", @"action":@"clickMyMark"},
                            @{@"image":@"icon_my_set", @"title":@"个人设置", @"action":@"clickSetting"},];
    }
    
    [self initUI];

    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.tableView.tableHeaderView = headView;
    
    _headImageView = [UIImageView new];
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.layer.cornerRadius = 25.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.borderWidth = 2.0;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    [headView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(60);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(clickHeadImage)];
    [_headImageView addGestureRecognizer:tapGesture];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"比死鸟";
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.textColor = [UIColor whiteColor];
    [headView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.centerY.equalTo(_headImageView);
    }];
    
    _levelImage = [UIImageView new];
    _levelImage.image = [UIImage imageNamed:@"lv"];
    [headView addSubview:_levelImage];
    
    [_levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.centerY.equalTo(_nameLabel);
    }];
    
    _levelLabel1 = [UILabel new];
    _levelLabel1.text = @"23";
    _levelLabel1.font = [UIFont systemFontOfSize:12.0];
    _levelLabel1.textColor = [UIColor whiteColor];
    [headView addSubview:_levelLabel1];
    
    [_levelLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_levelImage.mas_right).offset(2);
        make.centerY.equalTo(_nameLabel);
    }];
    
    _progressView = [CCProgressView new];
    [headView addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView);
        make.top.equalTo(_headImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kProgressWidth, kProgressHeigth));
    }];

    [_progressView setProgress:0.8];
    
    _levelLabel2 = [UILabel new];
    _levelLabel2.text = @"LV24";
    _levelLabel2.font = [UIFont systemFontOfSize:12.0];
    _levelLabel2.textColor = [UIColor whiteColor];
    [headView addSubview:_levelLabel2];
    
    [_levelLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressView.mas_right).offset(5);
        make.centerY.equalTo(_progressView).offset(0);
    }];
    
    _levelDesc = [UILabel new];
    _levelDesc.text = @"400/600等级信息";
    _levelDesc.font = [UIFont systemFontOfSize:9.0];
    _levelDesc.textColor = [UIColor whiteColor];
    [headView addSubview:_levelDesc];

    [_levelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressView);
        make.top.equalTo(_progressView.mas_bottom).offset(5);
    }];

}

- (void)clickHeadImage {
    
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    PersonPageViewController *vc = [[PersonPageViewController alloc] init];
    vc.url = [Account shareManager].userModel.user.webapp_url;
    
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![self didSelectInitialViewController]) {
        [self setDidSelectInitialViewController:YES];

        _tabVc = [[NGTabBarViewController alloc] init];
        [[self wta_zoomNavigationController] setContentViewController:_tabVc];
        [[self wta_zoomNavigationController] hideLeftViewController:YES];
    }
    
    _nameLabel.text = [Account shareManager].userModel.user.name;
    [_headImageView setImageWithURL:[NSURL URLWithString:[Account shareManager].userModel.user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return viewControllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idfa = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:idfa];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfa];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.tag = 100;
        [cell.contentView addSubview:iconImageView];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor whiteColor];
        label.tag = 101;
        [cell.contentView addSubview:label];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.centerY.mas_equalTo(0);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.centerY.mas_equalTo(0);
        }];
    }
    NSDictionary *dict = viewControllers[indexPath.row];
    UIImageView *iconImageView = [cell viewWithTag:100];
    UILabel *label = [cell viewWithTag:101];
    iconImageView.image = [UIImage imageNamed:dict[@"image"]];
    label.text = dict[@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = viewControllers[indexPath.row];
    SEL method = NSSelectorFromString(dict[@"action"]);
    [self performSelectorOnMainThread:method withObject:nil waitUntilDone:NO];
}

- (void)clickStudyTask {
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    MyTaskViewController *vc = [[MyTaskViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:vc animated:YES];
}

- (void)clickStudyRecord {
    
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    MyStudyRecordController *vc = [[MyStudyRecordController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:vc animated:YES];

}

- (void)clickMyAnswer {
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    MyQuestionController *vc = [[MyQuestionController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:vc animated:YES];
}

- (void)clickMyMark {
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    MyMarkViewController *vc = [[MyMarkViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:vc animated:YES];
}

- (void)clickSetting {
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    SetViewController *setVc = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    setVc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:setVc animated:YES];
}

/*********teacher*********/ 

/**
 *  点击我的课程
 */
- (void)clickMyCourse {
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    
    TEMyCourseListViewController *recommendVc = [[TEMyCourseListViewController alloc] init];
    recommendVc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:recommendVc animated:YES];
}

/**
 *  点击课程推荐
 */
- (void)clickCourseRecommend {
    
    [[self wta_zoomNavigationController] hideLeftViewController:YES];
    
    TERecommendViewController *recommendVc = [[TERecommendViewController alloc] init];
    recommendVc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)_tabVc.viewControllers[_tabVc.selectedIndex];
    [nav pushViewController:recommendVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
