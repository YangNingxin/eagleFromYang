//
//  TaskStatusViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/31.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TaskStatusViewController.h"
#import "TaskUserCell.h"

@interface TaskStatusViewController ()
{
    TaskStatueModel *taskStatusModel;
}
@end

@implementation TaskStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TaskUserCell" bundle:nil]
          forCellWithReuseIdentifier:@"TaskUserCell"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    [self.collectionView.header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)getDataFromServer {
    [DataHelper getStudentsStatusByTaskAndClass:self.taskId openclass_id:self.openclassId success:^(id responseObject) {
        taskStatusModel = responseObject;
        if (taskStatusModel.error_code == 0) {
            [self.collectionView reloadData];
        }
        [self.collectionView.header endRefreshing];
    } fail:^(NSError *error) {
        [self.collectionView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"完成状态";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return taskStatusModel.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    TaskUser *taskUser = taskStatusModel.data[indexPath.row];
    TaskUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskUserCell" forIndexPath:indexPath];
    cell.taskUser = taskUser;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake( (SCREEN_WIDTH - 10) / 3 , 50);
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
