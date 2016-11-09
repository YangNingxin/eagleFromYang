//
//  SubjectViewController.m
//  NGEagle
//
//  Created by Liang on 15/9/1.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SubjectViewController.h"
#import "SifterCell.h"
#import "SifterHeadView.h"

static NSString *const ID = @"Cell";
static NSString *const HEADID = @"Head";

@interface SubjectViewController ()
{
    NSOperation *_request;
}
@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-10)/3, 35);
    //        layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    
    // 创建UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:
                           CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT) collectionViewLayout:layout];
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
    
    BlockWeakObject(self, blockSelf);
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf getDataFromServer];
    }];
    
    [self.collectionView.header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
    
    [_request cancel];
    _request = nil;
    
    _request = [DataHelper getAllSubjectInfoForXuehu:^(id responseObject) {
        
        [self.collectionView.header endRefreshing];

        self.subjectModel = responseObject;
        if (self.subjectModel.error_code == 0) {
            [self.collectionView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)setCompletion:(CompletionBlock)block {

    _block = block;
}

/**
 *  完成按钮事件
 */
- (void)rightButtonAction {
    
    NSMutableString *subjectIds = [[NSMutableString alloc] init];
    NSMutableString *subjectNames = [[NSMutableString alloc] init];
    
    for (IntSubject *intSubject in self.subjectModel.data) {
        for (Subject *subject in intSubject.sub) {
            if (subject.isSelected) {
                [subjectIds appendFormat:@"%d,", subject.sid];
                [subjectNames appendFormat:@"%@、", subject.name];
            }
        }
    }
    if (subjectIds.length > 1) {
        
        subjectIds = (NSMutableString *)[subjectIds substringToIndex:subjectIds.length-1];
    }
    if (subjectNames.length > 1) {
        subjectNames = (NSMutableString *)[subjectNames substringToIndex:subjectNames.length-1];
    }
    _block(subjectIds, subjectNames);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"擅长学科";
    
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UICollectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    IntSubject *filter = self.subjectModel.data[section];
    return filter.sub.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.subjectModel.data.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 35);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SifterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    IntSubject *filter = self.subjectModel.data[indexPath.section];
    Subject *item = filter.sub[indexPath.row];
    if (item.isSelected) {
        cell.contentLabel.textColor = RGB(99, 192, 186);
    } else {
        cell.contentLabel.textColor = [UIColor blackColor];
    }
    cell.contentLabel.text = item.name;
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SifterHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADID forIndexPath:indexPath];
    
    IntSubject *filter = self.subjectModel.data[indexPath.section];
    headView.contentLabel.text = filter.name;
    
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IntSubject *filter = self.subjectModel.data[indexPath.section];
    Subject *item = filter.sub[indexPath.row];
    item.isSelected = !item.isSelected;
   
    [self.collectionView reloadData];
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
