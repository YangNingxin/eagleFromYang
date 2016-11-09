//
//  SifterCourseView.m
//  NGEagle
//
//  Created by Liang on 15/7/21.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SifterCourseView.h"
#import "SifterCell.h"
#import "SifterHeadView.h"
#import "CourseHelper.h"
#import "CourseFilterListModel.h"


static NSString *const ID = @"Cell";
static NSString *const HEADID = @"Head";

@implementation SifterCourseView
{
    int _subject;
    int _grade;
    int _channel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float space = 10;
        float itemSize = (SCREEN_WIDTH - space * 5) / 4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemSize, 30);
        layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
        // 创建UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height - 50) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"SifterCell" bundle:nil]
              forCellWithReuseIdentifier:ID];
        
        [self.collectionView registerClass:[SifterHeadView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:HEADID];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, self.height-45, SCREEN_WIDTH-20, 40)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.backgroundColor = kThemeColor;
        button.layer.cornerRadius = 4;
//        button.layer.borderColor = RGB(99, 192, 186).CGColor;
//        button.layer.borderWidth = 1.0;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonSureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
//        BlockWeakObject(self, blockSelf);
//        [self.collectionView addLegendHeaderWithRefreshingBlock:^{
//            [blockSelf getDataFromServer];
//        }];
        if (![CourseFilterListModel shareManager].resultData) {
            [self getDataFromServer];
        }
    }
    return self;
}

- (void)setType:(int)type {
    _type = type;
}
- (void)getDataFromServer {
    
    [_courseRequest cancel];
    _courseRequest = nil;
    
    _courseRequest = [CourseHelper getCourseTypeFilters:^(id responseObject) {
        CourseFilterListModel *listModel = responseObject;
        if (listModel.error_code == 0) {
            [CourseFilterListModel shareManager].resultData = listModel.data;
            [self.collectionView reloadData];
        }
//        [self.collectionView.header endRefreshing];

    } fail:^(NSError *error) {
//        [self.collectionView.header endRefreshing];
    }];
}

- (void)buttonSureAction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(_subject) forKey:@"subject_id"];
    [params setObject:@(_grade) forKey:@"grade_id"];
    [params setObject:@(_channel) forKey:@"course_type"];
    [params setObject:@(self.type) forKey:@"stage_id"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"filterCourseList" object:nil userInfo:params];
//    for (CourseFilter *courseFilter in self.courseFilterModel.data) {
//        for (Item *item in courseFilter.items) {
//            if ([item getSelect]) {
//                
//                [params setObject:@(item.itemId) forKey:courseFilter.param];
//            }
//        }
//    }
    [self.delegate didSelectItemAtIndexPathWithParams:params];
}


#pragma mark
#pragma mark UICollectionDelegate 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    KnowledgeType *knowledgeType = [CourseFilterListModel shareManager].resultData.knowledges[self.type];

    if (section == 0) {
        return knowledgeType.subjects.count;
    } else if (section == 1) {
        return knowledgeType.grades.count;
    }
    return [CourseFilterListModel shareManager].resultData.courses.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SifterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    FilterItem *item;
    
    KnowledgeType *knowledgeType = [CourseFilterListModel shareManager].resultData.knowledges[self.type];

    if (indexPath.section == 0) {
        item = knowledgeType.subjects[indexPath.row];
        if (_subject == item.fid) {
            cell.contentLabel.textColor = kThemeColor;
            cell.contentView.layer.borderColor = kThemeColor.CGColor;
        } else {
            cell.contentLabel.textColor = UIColorFromRGB(0x333333);
            cell.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        }
    } else if (indexPath.section == 1) {
        item = knowledgeType.grades[indexPath.row];
        if (_grade == item.fid) {
            cell.contentLabel.textColor = kThemeColor;
            cell.contentView.layer.borderColor = kThemeColor.CGColor;
        } else {
            cell.contentLabel.textColor = UIColorFromRGB(0x333333);
            cell.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        }
    } else {
        item = [CourseFilterListModel shareManager].resultData.courses[indexPath.row];
        if (_channel == item.fid) {
            cell.contentLabel.textColor = kThemeColor;
            cell.contentView.layer.borderColor = kThemeColor.CGColor;
        } else {
            cell.contentLabel.textColor = UIColorFromRGB(0x333333);
            cell.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        }
    }
    
//    CourseFilter *courseFilter = self.courseFilterModel.data[indexPath.section];
//    Item *item = courseFilter.items[indexPath.row];
//    if ([item getSelect]) {
//        cell.contentLabel.textColor = kThemeColor;
//        cell.contentView.layer.borderColor = kThemeColor.CGColor;
//    } else {
//        cell.contentLabel.textColor = UIColorFromRGB(0x333333);
//        cell.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
//    }

    cell.contentLabel.text = [NSString stringWithFormat:@" %@ ", item.name];

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SifterHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADID forIndexPath:indexPath];
    
//    CourseFilter *courseFilter = self.courseFilterModel.data[indexPath.section];
//    headView.contentLabel.text = courseFilter.name;

    switch (indexPath.section) {
        case 0:
            headView.contentLabel.text = @"学科";
            break;
        case 1:
            headView.contentLabel.text = @"年级";
            break;
        case 2:
            headView.contentLabel.text = @"频道";
            break;
        default:
            break;
    }
    
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FilterItem *item;
    
    KnowledgeType *knowledgeType = [CourseFilterListModel shareManager].resultData.knowledges[self.type];
    
    if (indexPath.section == 0) {
        item = knowledgeType.subjects[indexPath.row];
        _subject = item.fid;
    } else if (indexPath.section == 1) {
        item = knowledgeType.grades[indexPath.row];
        _grade = item.fid;
    } else {
        item = [CourseFilterListModel shareManager].resultData.courses[indexPath.row];
        _channel = item.fid;
    }
    
//    CourseFilter *courseFilter = self.courseFilterModel.data[indexPath.section];
//    for (Item *item in courseFilter.items) {
//        [item setSelect:NO];
//    }
//    Item *selectItem = courseFilter.items[indexPath.row];
//    if (item.getSelect) {
//        [item setSelect:NO];
//    } else {
//        [item setSelect:YES];
//    }
    
    [self.collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
