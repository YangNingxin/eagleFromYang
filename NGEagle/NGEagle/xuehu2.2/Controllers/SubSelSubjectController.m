//
//  SubSelSubjectController.m
//  NGEagle
//
//  Created by Liang on 16/4/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SubSelSubjectController.h"
#import "SifterCell.h"
#import "SifterHeadView.h"
#import "StageAndSubjectsModel.h"
#import "CourseHelper.h"

static NSString *const ID = @"Cell";
static NSString *const HEADID = @"Head";

@interface SubSelSubjectController ()
{
    int stage_id;
    int subject_id;
    NSString *desc;
    StageAndSubjectsModel *_stageAndSubjects;
    
    CompelteSubject _block;
}
@end

@implementation SubSelSubjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    float space = 10;
    float itemSize = (SCREEN_WIDTH - space * 5) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemSize, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    layout.minimumLineSpacing = space;
    layout.minimumInteritemSpacing = space;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    // 创建UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SifterCell" bundle:nil]
          forCellWithReuseIdentifier:ID];
    
    [self.collectionView registerClass:[SifterHeadView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:HEADID];
    
    WS(weakSelf);
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [self.collectionView.header beginRefreshing];
}

- (void)getDataFromServer {
    [CourseHelper getStageAndSubjects:^(id responseObject) {
        _stageAndSubjects = responseObject;
        if (_stageAndSubjects.error_code == 0) {
            [self.collectionView reloadData];
        }
        [self.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        [self.collectionView.header endRefreshing];
    }];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"选择学科";
    _rightButotn.hidden = NO;
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)setCompelte:(CompelteSubject)block {
    _block = block;
}
#pragma mark
#pragma mark UICollectionDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _stageAndSubjects.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    StageAndSubjects *subject = _stageAndSubjects.data[section];
    return subject.subjects.count;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SifterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    StageAndSubjects *subject = _stageAndSubjects.data[indexPath.section];
    SubjectModel *model = subject.subjects[indexPath.row];
    cell.contentLabel.text = [NSString stringWithFormat:@" %@ ", model.name];

    if (subject.sid == stage_id && model.sid == subject_id) {
        cell.contentLabel.textColor = kThemeColor;
        cell.contentView.layer.borderColor = kThemeColor.CGColor;
    } else {
        cell.contentLabel.textColor = UIColorFromRGB(0x333333);
        cell.contentView.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SifterHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADID forIndexPath:indexPath];
    
    StageAndSubjects *subject = _stageAndSubjects.data[indexPath.section];

    headView.contentLabel.text = subject.name;
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StageAndSubjects *subject = _stageAndSubjects.data[indexPath.section];
    SubjectModel *model = subject.subjects[indexPath.row];
    
    stage_id = subject.sid;
    subject_id = model.sid;
    
    desc = [NSString stringWithFormat:@"%@%@", subject.name, model.name];
    [self.collectionView reloadData];
}

- (void)rightButtonAction {
    if (_block && stage_id != 0 && subject_id != 0) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:desc forKey:@"desc"];
        [dict setObject:@(stage_id) forKey:@"stage_id"];
        [dict setObject:@(subject_id) forKey:@"subject_id"];
        _block(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
