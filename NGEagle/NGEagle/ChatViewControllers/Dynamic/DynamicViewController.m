//
//  QuestionDetailController.m
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DynamicViewController.h"
#import "ChatDataHelper.h"
#import "DynamicsListModel.h"
#import "NSString+Hashing.h"
#import "FCFileManager.h"
#import "DownLoadHelper.h"
#import "EMVoiceConverter.h"
#import "EGPlayAudio.h"
#import "DynamicDetailViewController.h"

@interface DynamicViewController ()
{
    NSMutableArray *_dataArray;
    
    // 来标记当前要播放的
    Dynamics *_currentDynamics;
}
@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 244);

    _dataArray = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 注册cell
    [_tableView registerClass:[AudioQuestionCell class] forCellReuseIdentifier:@"AudioQuestionCell"];
    [_tableView registerClass:[ImageQuestionCell class] forCellReuseIdentifier:@"ImageQuestionCell"];
    [_tableView registerClass:[VideoQuestionCell class] forCellReuseIdentifier:@"VideoQuestionCell"];
    
    _audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell"];
    _imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell"];
    _videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell"];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
    
    
    // Do any additional setup after loading the view.
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    WS(weakSelf);
    
    NSString *tempId;
    Dynamics *tempDynamics;
    if (_dataArray.count > 0) {
        if (isRefresh) {
            tempDynamics = _dataArray[0];
        } else {
            tempDynamics = _dataArray.lastObject;
        }
        tempId = tempDynamics.dynamicId;

    } else {
        tempId = @"0";
    }
    [ChatDataHelper getDynamicListWithCurrentId:tempId newer:isRefresh type:-1 gid:nil other_uid:nil num:20 success:^(id responseObject) {
        DynamicsListModel *model = responseObject;
        if (model.error_code == 0) {
            
            if (isRefresh) {
                if (_dataArray.count == 0) {
                    [_dataArray addObjectsFromArray:model.dynamics];

                } else {
                    int number = (int)model.dynamics.count - 1;
                    for (int i = number; i >= 0; i--) {
                        [_dataArray insertObject:model.dynamics[i] atIndex:0];
                    }
                }
                
            } else {
                [_dataArray addObjectsFromArray:model.dynamics];
            }
            
            if (!_tableView.footer) {
                [_tableView addLegendFooterWithRefreshingBlock:^{
                    [weakSelf getDataFromServer:NO];
                }];
            }
            [_tableView reloadData];
        }
        [_tableView.header endRefreshing];
        if (_tableView.footer) {
            [_tableView.footer endRefreshing];
        }
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
        if (_tableView.footer) {
            [_tableView.footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dynamics *model = _dataArray[indexPath.row];
    if (model.type == 1) {
        _imageCell.dynamic = model;
        _imageCell.imageArray = model.imageArray;
        CGSize size = [_imageCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    } else if (model.type == 3) {
        
        _audioCell.dynamic = model;
        CGSize size = [_audioCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    } else if (model.type == 2) {
        _videoCell.dynamic = model;
        CGSize size = [_videoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dynamics *model = _dataArray[indexPath.row];

    if (model.type == 1) {
        ImageQuestionCell  *imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell" forIndexPath:indexPath];
        imageCell.delegate = self;
        imageCell.imageArray = model.imageArray;
        imageCell.dynamic = model;
        [imageCell changeStyleToDynamic];
        return imageCell;
    } else if (model.type == 3) {
        AudioQuestionCell *audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell" forIndexPath:indexPath];
        audioCell.delegate = self;
        audioCell.dynamic = model;
        [audioCell changeStyleToDynamic];
        return audioCell;
    } else {
        VideoQuestionCell *videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell" forIndexPath:indexPath];
        videoCell.dynamic = model;
        [videoCell changeStyleToDynamic];
        return videoCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Dynamics *model = _dataArray[indexPath.row];

    DynamicDetailViewController *dynamicVc = [[DynamicDetailViewController alloc] init];
    dynamicVc.dynamics = model;
    dynamicVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicVc animated:YES];
}

#pragma mark AudioQuestionCellDelegate
- (void)clickAudioView:(Dynamics *)dynamic {
    
    if (dynamic.status == 0) {
        
        // 如果存在，并且是正在播放，就暂停掉
        if (_currentDynamics) {
            if (_currentDynamics.status == 2) {
                [self stopPlayAudio:_currentDynamics];
            }
        }
        
        Resource *resource = dynamic.resource[0];
        NSString *strVideoURL = resource.url;
        
        NSString *fileName = [NSString stringWithFormat:@"%@.amr",[strVideoURL MD5Hash]];
        NSString *fileNameWAV = [NSString stringWithFormat:@"%@.wav",[strVideoURL MD5Hash]];
        
        NSString *filePath = [FCFileManager pathForCachesDirectoryWithPath:fileName];
        NSString *filePathWAV = [FCFileManager pathForCachesDirectoryWithPath:fileNameWAV];
        
        if ([FCFileManager existsItemAtPath:filePath]) {
            if ([FCFileManager existsItemAtPath:filePathWAV]) {
                [self startPlayAudio:dynamic filePath:filePathWAV];
            } else {
                dynamic.status = 1;
                // 转码
                [EMVoiceConverter amrToWav:filePath wavSavePath:filePathWAV];
                [self startPlayAudio:dynamic filePath:filePathWAV];
            }
        } else {
            dynamic.status = 1;
            // 先下载
            [DownLoadHelper downLoadFileWithURL:strVideoURL saveFilePath:filePath backBlock:^(int status) {
                if (status == 0) {
                    // 转码
                    [EMVoiceConverter amrToWav:filePath wavSavePath:filePathWAV];
                    [self startPlayAudio:dynamic filePath:filePathWAV];
                } else {
                    dynamic.status = 0;
                }
            }];
        }
    } else if (dynamic.status == 1) {
        // do nothing
    } else if (dynamic.status == 2) {
        // 停止播放
        [self stopPlayAudio:dynamic];
    }
    // 立即赋值
    _currentDynamics = dynamic;
}

- (void)startPlayAudio:(Dynamics *)dynamic filePath:(NSString *)filePath {
    
    // 如果需要播放的和当前的对等，就播放
    
    if (dynamic == _currentDynamics) {
        // 播放
        [[EGPlayAudio shareEGPlayAudio] playAudioWithPath:filePath endPlay:^{
            dynamic.status = 0;
        }];
        dynamic.status = 2;
    }
}

- (void)stopPlayAudio:(Dynamics *)dynamic {
    [[EGPlayAudio shareEGPlayAudio] stopPlay];
    dynamic.status = 0;
}

#pragma mark ImageQuestionCellDelegate
- (void)clickAdvisoryCellImage:(NSIndexPath *)indexPath imagesArray:(NSArray *)imagesArray {
    MyPhotoBrowserController *photoVc = [[MyPhotoBrowserController alloc] init];
    photoVc.index = indexPath.row;
    photoVc.imagesArray = imagesArray;
    [self.navigationController pushViewController:photoVc animated:YES];
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
