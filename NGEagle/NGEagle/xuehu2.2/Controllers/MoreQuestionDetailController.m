//
//  MyQuestionController.m
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MoreQuestionDetailController.h"
#import "CourseHelper.h"
#import "QuestionListModel.h"
#import "NSString+Hashing.h"
#import "FCFileManager.h"
#import "DownLoadHelper.h"
#import "EMVoiceConverter.h"
#import "EGPlayAudio.h"
#import "CreateQuestionViewController.h"
#import "QuestionDetailController.h"
#import "ShareView.h"
#import "ReportViewController.h"
#import "MoreQuestionDetailController.h"
#import "Account.h"
#import "CreateAnswerViewController.h"

@interface MoreQuestionDetailController ()
{
    NSMutableArray *_dataArray;
    CCQuestion *_currentQuestion;
    UIButton *_answerButton;
}

@end

@implementation MoreQuestionDetailController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _imageCell = [[ImageQuestionCell alloc] initWithChatStyle:@"ImageQuestionCell"];
    _audioCell = [[AudioQuestionCell alloc] initWithChatStyle:@"AudioQuestionCell"];
    _videoCell = [[VideoQuestionCell alloc] initWithChatStyle:@"VideoQuestionCell"];
    // Do any additional setup after loading the view.
    
    _answerButton = [UIButton new];
    [_answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _answerButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    _answerButton.layer.cornerRadius = 4.0;
    _answerButton.layer.masksToBounds = YES;
    _answerButton.backgroundColor = kThemeColor;
    [self.view addSubview:_answerButton];
    
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-5);
        make.height.mas_offset(40);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(0);
    }];
    
    if (self.isMyQuestion) {
        [_answerButton setTitle:@"我要追问" forState:UIControlStateNormal];
    } else {
        [_answerButton setTitle:@"我要回答" forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    WS(weakSelf);
    
    [CourseHelper getContinueAskDetailByQuestionId:self.questionId answer_id:self.answerId success:^(id responseObject) {
        
        QuestionListModel *model = responseObject;
        if (model.error_code == 0) {
            if (isRefresh) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:model.data];
            if (_dataArray.count == 0) {
                [weakSelf.view makeToast:@"数据为空" duration:1.0 position:@"bottom"];
            }
        }
        [_tableView reloadData];
        
        // 滑动到底部
        if (_dataArray.count > 0) {
             [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
       
        [_tableView.header endRefreshing];
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

- (void)configBaseUI {
    _titleLabel.text = @"问答详情";
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
        
        static NSString *reuseIdentifier = @"ImageQuestionCell";
        ImageQuestionCell  *imageCell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!imageCell) {
            imageCell = [[ImageQuestionCell alloc] initWithChatStyle:reuseIdentifier];
        }
        imageCell.delegate = self;
        imageCell.imageArray = model.imageArray;
        imageCell.question = model;
        
        if (model.obj_type_id == 702) {
            [imageCell setRight];
        } else {
            [imageCell setLeft];
        }

        return imageCell;
        
    } else if (model.resourceType == 3) {
    
        static NSString *reuseIdentifier = @"AudioQuestionCell";
        AudioQuestionCell  *audioCell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!audioCell) {
            audioCell = [[AudioQuestionCell alloc] initWithChatStyle:reuseIdentifier];
        }
        audioCell.delegate = self;
        audioCell.question = model;
        
        if (model.obj_type_id == 702) {
            [audioCell setRight];
        } else {
            [audioCell setLeft];
        }

        return audioCell;
    } else {
    
        static NSString *reuseIdentifier = @"VideoQuestionCell";
        VideoQuestionCell *videoCell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!videoCell) {
            videoCell = [[VideoQuestionCell alloc] initWithChatStyle:reuseIdentifier];
        }
        
        videoCell.question = model;
        if (model.obj_type_id == 702) {
            [videoCell setRight];
        } else {
            [videoCell setLeft];
        }
        
        return videoCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (void)answerAction {

    int tempId;
    CCQuestion *tempQustion = _dataArray.lastObject;
    tempId = tempQustion.qid;
    
    // 追问
    if (self.isMyQuestion) {
        CreateQuestionViewController *publishVc = [[CreateQuestionViewController alloc] init];
        publishVc.closely_answer_id = tempId;
        [publishVc setCreateQuestionSuccess:^(CreateQuestionModel *object) {
            [_tableView.header beginRefreshing];
        }];
        [self.navigationController pushViewController:publishVc animated:YES];
    } else { // 回答
        CreateAnswerViewController *createVc = [[CreateAnswerViewController alloc]init];
        createVc.question_id = tempId;
        [createVc setCreateAnswerSuccess:^(CreateAnswerModel *object) {
            [_tableView.header beginRefreshing];
        }];
        [self.navigationController pushViewController:createVc animated:YES];
    }
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
