//
//  CCCourseListController.m
//  NGEagle
//
//  Created by Liang on 16/4/6.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCCourseListController.h"
#import "CollectionCourseCell.h"
#import "RecommendHeadView.h"
#import "CCCourseDetailController.h"
#import "CategoryViewController.h"
#import "CCSearchViewController.h"
#import "CourseHelper.h"
#import "CCCourseListModel.h"
#import "CourseFilterListModel.h"
#import "LeftLabelRightImage.h"

@interface CCCourseListController () <UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecommendHeadViewDelegate>
{
    // view
    UIScrollView *_scrollView;
    UIButton *_pullButton;
    UICollectionView *_collectionView;
    UIImageView *_statueImageView;

    // data
    NSMutableArray *_dataArray;
    // 推荐的课程数据
    CCCourseListModel *_recommendListModel;
    
    // 0全部，1为其他
    int _type;
    int _select;
    int _schoolId;
    
    int page;
    int pageNum;
    NSMutableDictionary *_params;
    BOOL _isInitTopView;
    
    LeftLabelRightImage *_centerLabel;
    UIView *_popview;
}
@end

@implementation CCCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    pageNum = 20;
    _schoolId = 0;
    _dataArray = [NSMutableArray new];
    
    [self initUI];
    if (self.courseType == 1) {
//        _titleLabel.text = @"校内";
    } else if (self.courseType == 0) {
        _titleLabel.text = @"云课堂";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterCourseList:) name:@"filterCourseList" object:nil];
    // Do any additional setup after loading the view.
}

// 点击返回的时候，需要改变之前赋值的server地址
- (void)leftButtonAction {
    [super leftButtonAction];
    [Account shareManager].server = nil;
}

// 根据筛选条件，刷新数据
- (void)filterCourseList:(NSNotification *)aNote {
    _params = (NSMutableDictionary *)[aNote userInfo];
    int stage_id = [_params[@"stage_id"] intValue];
    
    @try {
        // 刷新UI
        UIButton *button = [_scrollView viewWithTag:10 + stage_id];
        if (button.tag == 10) {
            _type = 0;
        } else {
            _type = 1;
        }
        [UIView animateWithDuration:0.2 animations:^{
            _statueImageView.centerX = button.centerX;
        }];
        [self getCourseListFromServer:YES];
    } @catch (NSException *exception) {
        
    }
}

- (void)initUI {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    topView.backgroundColor = RGB(251, 251, 251);
    [self.view addSubview:topView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 40)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [topView addSubview:_scrollView];
    
    _statueImageView = [UIImageView new];
    _statueImageView.backgroundColor = kThemeColor;
    _statueImageView.frame = CGRectMake(0, 38, 40, 2);
    [_scrollView addSubview:_statueImageView];
    
    _pullButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 40)];
    [_pullButton addTarget:self action:@selector(pullDownAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pullButton setImage:[UIImage imageNamed:@"icon_pull"] forState:UIControlStateNormal];
    [topView addSubview:_pullButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB(204, 204, 204);
    [topView addSubview:lineView];
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 竖直方向滚动
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    // 左右最小间距
    flowLayout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:
                       CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT - 105)
                                         collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = RGB(251, 251, 251);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CollectionCourseCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[RecommendHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
//    [_collectionView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];

    WS(weakSelf);
    [_collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getFilterFromServer];
        [weakSelf getRecommendCourseFromServer];
        
    }];
    
    // 开始刷新数据
    [_collectionView.header beginRefreshing];
}

// 初始化topView
- (void)initTopView {
    if (_isInitTopView) {
        return;
    }
 
    NSArray<KnowledgeType> *knowledges = [CourseFilterListModel shareManager].resultData.knowledges;
    
    for (int i = 0; i < [knowledges count]; i++) {
        
        KnowledgeType *type = knowledges[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:
                            CGRectMake(5 + i*60, 0, 60, 40)];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:type.name forState:UIControlStateNormal];
        [_scrollView addSubview:button];
    }
    
    [_scrollView setContentSize:CGSizeMake(knowledges.count * 60, 40)];
    _statueImageView.centerX = [_scrollView viewWithTag:10].centerX;
    
    _isInitTopView = YES;
    
    if (self.courseType == 1) {
        _centerLabel = [LeftLabelRightImage new];
        [_barImageView addSubview:_centerLabel];
        
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(32);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopView)];
        [_centerLabel addGestureRecognizer:tap];
        
        NSArray<DomainItem> *domins = [CourseFilterListModel shareManager].resultData.domain;
        DomainItem *domainItem = domins[0];
        _schoolId = domainItem.did;
        [self updateSchoolName:domainItem.name];
    }
}

- (void)showPopView {
    if (!_popview) {
        
        _popview = [UIView new];
        _popview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_popview];
        
        NSArray<DomainItem> *domins = [CourseFilterListModel shareManager].resultData.domain;

        UIButton *tempButton = nil;
        
        
        for (int i = 0; i < domins.count; i++) {
            
            DomainItem *domain = domins[i];
            
            UIButton *button = [UIButton new];
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [button setTitle:domain.name forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(selectSchool:) forControlEvents:UIControlEventTouchUpInside];
            [_popview addSubview:button];
            
            if (!tempButton) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(5);
                    make.right.top.mas_offset(0);
                    make.left.mas_offset(5);
                    make.height.mas_offset(40);
                }];
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(5);
                    make.right.mas_offset(0);
                    make.top.equalTo(tempButton.mas_bottom);
                    make.height.mas_offset(40);
                }];
            }
            tempButton = button;
            
            UIImageView *lineImageView = [UIImageView new];
            lineImageView.backgroundColor = RGB(230, 230, 230);
            [_popview addSubview:lineImageView];
            
            [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.top.equalTo(tempButton.mas_bottom);
                make.height.mas_offset(0.5);
            }];
        }
        
        [_popview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(64);
            make.left.right.mas_offset(0);
            make.height.mas_offset(domins.count * 40);
        }];
        
    } else {
        
        if (_popview.hidden) {
            _popview.hidden = NO;
        } else {
            _popview.hidden = YES;
        }
    }
}

/**
 *  选择学校
 *
 *  @param button
 */
- (void)selectSchool:(UIButton *)button {
    
    NSArray<DomainItem> *domins = [CourseFilterListModel shareManager].resultData.domain;

    DomainItem *domain = domins[button.tag - 1000];

    if (_schoolId == domain.did) {
        return;
    }
    _schoolId = domain.did;
    // 刷新数据
    [_collectionView.header beginRefreshing];
    [self updateSchoolName:domain.name];
    _popview.hidden = YES;
}

- (void)updateSchoolName:(NSString *)name {
    
    if (name.length > 9) {
        name = [name substringToIndex:8];
    }
    name = [NSString stringWithFormat:@"%@...", name];
    [_centerLabel initWithData:name image:[UIImage imageNamed:@"sanjiao"]];
}

- (void)getRecommendCourseFromServer {
    
    [CourseHelper getRecommendCourses:self.courseType success:^(id responseObject) {
        CCCourseListModel *listModel = responseObject;
        if (listModel.error_code == 0) {
            _recommendListModel = listModel;
            [_collectionView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)getCourseListFromServer:(BOOL)isRefresh {
    
    int tempPage;
    WS(weakSelf);
    
    if (isRefresh) {
        tempPage = 1;
    } else {
        tempPage = page;
    }
    
    [CourseHelper getWeikeList:tempPage num:pageNum type:1 school_id:_schoolId params:_params kw:nil self_flag:0 success:^(id responseObject) {
        
        CCCourseListModel *listModel = responseObject;
        if (listModel.error_code == 0) {
            if (isRefresh) {
                [_dataArray removeAllObjects];
                page = 1;
            }
            if (listModel.data.count == pageNum) {
                page ++;
                if (!_collectionView.footer) {
                    [_collectionView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getCourseListFromServer:NO];
                    }];
                }
            } else {
                [_collectionView removeFooter];
            }
            [_dataArray addObjectsFromArray:listModel.data];
        }

        [_collectionView reloadData];

        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
    } fail:^(NSError *error) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
    }];
}

- (void)getFilterFromServer {
    WS(weakself);
    
    if (![CourseFilterListModel shareManager].resultData) {
        [CourseHelper getCourseTypeFilters:^(id responseObject) {
            CourseFilterListModel *listModel = responseObject;
            if (listModel.error_code == 0) {
                [CourseFilterListModel shareManager].resultData = listModel.data;
                [weakself initTopView];
                
                // 获取筛选数据成功之后，刷新数据
                [weakself getCourseListFromServer:YES];
            }
        } fail:^(NSError *error) {
            
        }];
    } else {
        [self initTopView];
        [weakself getCourseListFromServer:YES];
    }
}

- (void)selectAction:(UIButton *)button {
    
    if (button.tag == 10) {
        _type = 0;
    } else {
        _type = 1;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _statueImageView.centerX = button.centerX;
    }];
    _select = (int)button.tag - 10;
    _params = [NSMutableDictionary new];
    [_params setObject:@(button.tag - 10) forKey:@"stage_id"];
    [self getCourseListFromServer:YES];
}

- (void)pullDownAction:(UIButton *)button {
    CategoryViewController *categoryVc = [[CategoryViewController alloc] init];
    categoryVc.type = _select;
    [self presentViewController:categoryVc animated:YES completion:nil];
}

- (void)configBaseUI {
    [_rightButotn setImage:[UIImage imageNamed:@"icon_serach2"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    CCSearchViewController *searchVc = [[CCSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)clickCourse:(CCCourse *)course {
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = course;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark
#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.course = _dataArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (_type != 0) {
        return nil;
    }
    if (kind == UICollectionElementKindSectionHeader) {
        RecommendHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        headView.delegate = self;
        headView.listModel = _recommendListModel;
        return headView;
    }
    return nil;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 30) / 2, 165);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (_type != 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(SCREEN_WIDTH, 245 + 10);
}

//定义每个section 的间距,上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择%ld",indexPath.row);
    CCCourseDetailController *detailVc = [[CCCourseDetailController alloc] init];
    detailVc.course = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
