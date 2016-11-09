//
//  MyQuestionController.m
//  NGEagle
//
//  Created by Liang on 16/4/20.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "QuestionDetailController.h"
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
#import "CreateAnswerViewController.h"

@interface QuestionDetailController ()
{
    int page;
    int num;
    NSMutableArray *_dataArray;
    CCQuestion *_currentQuestion;
    CCQuestion *_mainQuestion;
    UIButton *_answerButton;
    BOOL _isMyQuestion;
}

@end

@implementation QuestionDetailController

- (void)viewDidLoad {
    
   
    [super viewDidLoad];
    
    page = 1;
    num = 20;
    
    _dataArray = [NSMutableArray new];
    
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
    
    _answerButton = [UIButton new];
    [_answerButton setTitle:@"我要回答" forState:UIControlStateNormal];
    [_answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _answerButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    _answerButton.layer.cornerRadius = 4.0;
    _answerButton.hidden = YES;
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
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
}

- (void)getQuestionDetailFromServer {
 
    WS(weakSelf);

    // 1.0
    [CourseHelper getQuestionDetailQuestionId:self.questionId success:^(id responseObject) {
        QuestionDetailModel *model = responseObject;
        if (model.error_code == 0) {
            
            _mainQuestion = model.data;

            [_dataArray removeAllObjects];
            
            // 如果是自己的问题，隐藏回答按钮
            if (_mainQuestion.user_id != [[Account shareManager].userModel.user.uid intValue]) {
                _answerButton.hidden = NO;
                [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(-45);
                }];
                _isMyQuestion = NO;
            } else {
                _isMyQuestion = YES;
                _answerButton.hidden = YES;
                [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(0);
                }];
            }
            _mainQuestion.isQustionUI = YES;
            [_dataArray insertObject:_mainQuestion atIndex:0];
            
            int tempPage = 1;
            
            // 2.0
            [CourseHelper getQuestionAnswerByQuestionId:self.questionId page:tempPage num:num success:^(id responseObject) {
                
                QuestionListModel *model = responseObject;
                if (model.error_code == 0) {
                    page = 1;
                    if (model.data.count == num) {
                        page ++;
                        if (!_tableView.footer) {
                            [_tableView addLegendFooterWithRefreshingBlock:^{
                                [weakSelf getDataFromServer:NO];
                            }];
                        }
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
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)getDataFromServer:(BOOL)isRefresh {
    
    WS(weakSelf);
    int tempPage;
    
    if (isRefresh) {
        tempPage = 1;
        // 去获取详情数据
        [self getQuestionDetailFromServer];
    } else {
        tempPage = page;
        
        // 2.0
        [CourseHelper getQuestionAnswerByQuestionId:self.questionId page:tempPage num:num success:^(id responseObject) {
            
            QuestionListModel *model = responseObject;
            if (model.error_code == 0) {
                
                if (model.data.count == num) {
                    page ++;
                } else {
                    [_tableView removeFooter];
                }
                
                [_dataArray addObjectsFromArray:model.data];
                if (_dataArray.count == 0) {
                    [weakSelf.view makeToast:@"数据为空" duration:1.0 position:@"bottom"];
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
    
    
}

- (void)configBaseUI {
    _titleLabel.text = @"问答详情";
    _rightButotn.hidden = NO;
    [_rightButotn setImage:[UIImage imageNamed:@"icon_menu_more"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    
    
    WS(weakSelf);
    
    ShareView *shareView = [[ShareView alloc] init];
    [shareView setClickEventBlock:^(int index) {
        if (index == 6) {
            ReportViewController *reportVc = [[ReportViewController alloc] init];
            reportVc.type = 3;
            reportVc.target_id = weakSelf.questionId;
            [self.navigationController pushViewController:reportVc animated:YES];
        }
    }];
    [shareView show];
    
    //    UIImage *image = [UIImage imageNamed:@"icon_share"];
    //    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:@"内容--http://www.snslearn.com"
    //                                                         image:image location:nil urlResource:nil
    //                                           presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
    //        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //        }
    //    }];
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
        imageCell.isAnswerUI = YES;
        imageCell.isMyQuestion = _isMyQuestion;
        imageCell.delegate = self;
        imageCell.imageArray = model.imageArray;
        imageCell.question = model;
        imageCell.handleDelegate = self;
        return imageCell;
    } else if (model.resourceType == 3) {
        AudioQuestionCell *audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell" forIndexPath:indexPath];
        audioCell.isAnswerUI = YES;
        audioCell.isMyQuestion = _isMyQuestion;
        audioCell.delegate = self;
        audioCell.question = model;
        audioCell.handleDelegate = self;
        return audioCell;
    } else {
        VideoQuestionCell *videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell" forIndexPath:indexPath];
        videoCell.isAnswerUI = YES;
        videoCell.isMyQuestion = _isMyQuestion;
        videoCell.question = model;
        videoCell.handleDelegate = self;
        return videoCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // 其实本身是一个回答
    CCQuestion *model = _dataArray[indexPath.row];
    if (model.isQustionUI) {
        return;
    }
    MoreQuestionDetailController *viewController = [[MoreQuestionDetailController alloc] init];
    viewController.answerId = model.qid;
    viewController.questionId = self.questionId;
    viewController.isMyQuestion = _isMyQuestion;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handelAction:(int)eventType dataSource:(id)object {
    
    CCQuestion *question = object;

    // 0 采纳 -- 1 赞 -- 2 追问
    if (eventType == 100 || eventType == 1) { // 赞
        if (!question.is_agree) {
            [DataHelper supportByAction:YES type:2 target_id:question.qid success:^(id responseObject) {
                ErrorModel *model = responseObject;
                if (model.error_code == 0) {
                    question.is_agree = YES;
                    [_tableView reloadData];
                }
            } fail:^(NSError *error) {
                
            }];
        } else {
            [DataHelper supportByAction:NO type:2 target_id:question.qid success:^(id responseObject) {
                ErrorModel *model = responseObject;
                if (model.error_code == 0) {
                    question.is_agree = NO;
                    [_tableView reloadData];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    } else if (eventType == 0) { // 采纳
        if (!question.acception) {
            [CourseHelper acceptQuestionAnswer:self.questionId answer_id:question.qid success:^(id responseObject) {
                ErrorModel *model = responseObject;
                if (model.error_code == 0) {
                    question.acception = YES;
                    [_tableView reloadData];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    } else if (eventType == 2) { // 追问
        
        CreateQuestionViewController *publishVc = [[CreateQuestionViewController alloc] init];
        publishVc.closely_answer_id = question.qid;
        [publishVc setCreateQuestionSuccess:^(CreateQuestionModel *object) {

        }];
        [self.navigationController pushViewController:publishVc animated:YES];
    }
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
    CreateAnswerViewController *createVc = [[CreateAnswerViewController alloc] init];
    createVc.question_id = self.questionId;
    [createVc setCreateAnswerSuccess:^(CreateAnswerModel *object) {
        [_tableView.header beginRefreshing];
    }];
    [self.navigationController pushViewController:createVc animated:YES];
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
