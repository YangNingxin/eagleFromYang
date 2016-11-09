//
//  MyQuestionController.m
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MyQuestionController.h"
#import "CourseHelper.h"
#import "QuestionListModel.h"
#import "NSString+Hashing.h"
#import "FCFileManager.h"
#import "DownLoadHelper.h"
#import "EMVoiceConverter.h"
#import "EGPlayAudio.h"
#import "CreateQuestionViewController.h"
#import "QuestionDetailController.h"

@interface MyQuestionController ()
{
    UIView *topView;
    int _type;
    UIImageView *_statusImageView;
    NSOperation *_operation;
    
    int page;
    int num;
    NSMutableArray *_dataArray;
    CCQuestion *_currentQuestion;
}
@end

@implementation MyQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    num = 20;
    
    _dataArray = [NSMutableArray new];  
    
    topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.height.mas_offset(36);
    }];
    
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton new];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [topView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(i * SCREEN_WIDTH / 3);
            make.top.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH / 3);
            make.height.equalTo(topView);
        }];
        
        switch (i) {
            case 0:
                [button setTitle:@"我提问的" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"向我提问" forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:@"我回答的" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    _statusImageView = [UIImageView new];
    _statusImageView.backgroundColor = kThemeColor;
    [topView addSubview:_statusImageView];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
    }];
    
    _tableView = [UITableView new];
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
    // Do any additional setup after loading the view.
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(topView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(0);
    }];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
}

- (void)selectType:(UIButton *)btn {
    
    if (_type == btn.tag - 10) {
        return;
    }
    _type = (int)btn.tag - 10;
    
    [_statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo( _type * SCREEN_WIDTH / 3);
    }];
    
    // 刷新数据
    [_tableView.header beginRefreshing];
}


- (void)getDataFromServer:(BOOL)isRefresh {
    
    WS(weakSelf);
    
    int tempPage;
    
    if (isRefresh) {
        tempPage = 1;
        [_dataArray removeAllObjects];
        [_tableView reloadData];
    } else {
        tempPage = page;
    }
    
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    int questionType;
    if (_type == 0) {
        questionType = 1;
        
    } else if (_type == 1) {
        
        questionType = 0;
    } else {
        questionType = 2;
    }
    
    _operation = [CourseHelper getQuestionListByType:questionType status:-1 page:tempPage num:num structure_ids:nil kw:nil success:^(id responseObject) {
        
        QuestionListModel *model = responseObject;
        if (model.error_code == 0) {
            if (isRefresh) {
                page = 1;
            }
            if (model.data.count == num) {
                page ++;
                if (!_tableView.footer) {
                    [_tableView addLegendFooterWithRefreshingBlock:^{
                        [weakSelf getDataFromServer:NO];
                    }];
                }
            } else {
                [_tableView removeFooter];
            }
            
            [_dataArray addObjectsFromArray:model.data];
            if (_dataArray.count == 0) {
                [self.view makeToast:@"数据为空" duration:1.0 position:@"bottom"];
            }
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)configBaseUI {
    _titleLabel.text = @"我的问答";
    _rightButotn.hidden = NO;
    [_rightButotn setTitle:@"去提问" forState:UIControlStateNormal];
    _rightButotn.frame = CGRectMake(SCREEN_WIDTH - 60, 25, 50, 34);
}

- (void)rightButtonAction {
    CreateQuestionViewController *publishVc = [[CreateQuestionViewController alloc] init];
    [self.navigationController pushViewController:publishVc animated:YES];
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
    
    CCQuestion *model = _dataArray[indexPath.row];
    
    if (model.resourceType == 1) {
        
        _imageCell.question = model;
        _imageCell.imageArray = model.imageArray;
        CGSize size = [_imageCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
        
    } else if (model.resourceType == 3) {
        
        _audioCell.question = model;
        CGSize size = [_audioCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
        
    } else if (model.resourceType == 2) {
        
        _videoCell.question = model;
        CGSize size = [_videoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCQuestion *model = _dataArray[indexPath.row];
    
    if (model.resourceType == 1) {
        ImageQuestionCell  *imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell" forIndexPath:indexPath];
        imageCell.delegate = self;
        imageCell.imageArray = model.imageArray;
        imageCell.question = model;
        return imageCell;
    } else if (model.resourceType == 3) {
        AudioQuestionCell *audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell" forIndexPath:indexPath];
        audioCell.delegate = self;
        audioCell.question = model;

        return audioCell;
    } else {
        VideoQuestionCell *videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell" forIndexPath:indexPath];
        videoCell.question = model;

        return videoCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCQuestion *model = _dataArray[indexPath.row];

    QuestionDetailController *viewController = [[QuestionDetailController alloc] init];
    viewController.questionId = model.qid;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark AudioQuestionCellDelegate
- (void)clickAudioView2:(CCQuestion *)question {
    
    if (question.playStatus == 0) {
        
        // 如果存在，并且是正在播放，就暂停掉
        if (_currentQuestion) {
            if (_currentQuestion.playStatus == 2) {
                [self stopPlayAudio:_currentQuestion];
            }
        }
        MediaObject *meida = question.resource.audio[0];
        
        NSString *strVideoURL = meida.url;
        
        NSString *fileName = [NSString stringWithFormat:@"%@.amr",[strVideoURL MD5Hash]];
        NSString *fileNameWAV = [NSString stringWithFormat:@"%@.wav",[strVideoURL MD5Hash]];
        
        NSString *filePath = [FCFileManager pathForCachesDirectoryWithPath:fileName];
        NSString *filePathWAV = [FCFileManager pathForCachesDirectoryWithPath:fileNameWAV];
        
        if ([FCFileManager existsItemAtPath:filePath]) {
            if ([FCFileManager existsItemAtPath:filePathWAV]) {
                [self startPlayAudio:question filePath:filePathWAV];
            } else {
                question.playStatus = 1;
                // 转码
                [EMVoiceConverter amrToWav:filePath wavSavePath:filePathWAV];
                [self startPlayAudio:question filePath:filePathWAV];
            }
        } else {
            question.playStatus = 1;
            // 先下载
            [DownLoadHelper downLoadFileWithURL:strVideoURL saveFilePath:filePath backBlock:^(int status) {
                if (status == 0) {
                    // 转码
                    [EMVoiceConverter amrToWav:filePath wavSavePath:filePathWAV];
                    [self startPlayAudio:question filePath:filePathWAV];
                } else {
                    question.playStatus = 0;
                }
            }];
        }
    } else if (question.playStatus == 1) {
        // do nothing
    } else if (question.playStatus == 2) {
        // 停止播放
        [self stopPlayAudio:question];
    }
    // 立即赋值
    _currentQuestion = question;
}

- (void)startPlayAudio:(CCQuestion *)question filePath:(NSString *)filePath {
    
    // 如果需要播放的和当前的对等，就播放
    
    if (question == _currentQuestion) {
        // 播放
        [[EGPlayAudio shareEGPlayAudio] playAudioWithPath:filePath endPlay:^{
            question.playStatus = 0;
        }];
        question.playStatus = 2;
    }
}

- (void)stopPlayAudio:(CCQuestion *)question {
    [[EGPlayAudio shareEGPlayAudio] stopPlay];
    question.playStatus = 0;
}


#pragma mark ImageQuestionCellDelegate
- (void)clickAdvisoryCellImage:(NSIndexPath *)indexPath imagesArray:(NSArray *)imagesArray {
    MyPhotoBrowserController *photoVc = [[MyPhotoBrowserController alloc] init];
    photoVc.index = indexPath.row;
    photoVc.imagesArray = imagesArray;
    [self.navigationController pushViewController:photoVc animated:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
