//
//  DynamicDetailViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "ChatDataHelper.h"
#import "DynamicsListModel.h"
#import "NSString+Hashing.h"
#import "FCFileManager.h"
#import "DownLoadHelper.h"
#import "EMVoiceConverter.h"
#import "EGPlayAudio.h"
#import "DynamicsCommentModel.h"
#import "DynamicCommentCell.h"
#import "DXMessageToolBar.h"

@interface DynamicDetailViewController () <DynamicCommentCellDelegate, DXMessageToolBarDelegate>
{
    /**
     *  评论类型，0为评论，1为回复
     */
    int _commentType;
    
    NSMutableArray *_dataArray;
    // 来标记当前要播放的
    Dynamics *_currentDynamics;
    
    // 标记当前评论
    CommentObject *_currentComment;
    User *_currentUser;
    
    DynamicCommentCell *_commentCell;
}
@property (nonatomic, strong) DXMessageToolBar *chatToolBar;
@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 244);
    _titleLabel.text = @"动态详情";
    _dataArray = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.bottom.mas_offset(-44);
    }];
    
    // 注册cell
    [_tableView registerClass:[AudioQuestionCell class] forCellReuseIdentifier:@"AudioQuestionCell"];
    [_tableView registerClass:[ImageQuestionCell class] forCellReuseIdentifier:@"ImageQuestionCell"];
    [_tableView registerClass:[VideoQuestionCell class] forCellReuseIdentifier:@"VideoQuestionCell"];
    [_tableView registerClass:[DynamicCommentCell class] forCellReuseIdentifier:@"DynamicCommentCell"];
    
    _audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell"];
    _imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell"];
    _videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell"];
    _commentCell = [_tableView dequeueReusableCellWithIdentifier:@"DynamicCommentCell"];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServer:YES];
    }];
    [_tableView.header beginRefreshing];
    
    [self initBottomView];
    [self addCommentView];
    // Do any additional setup after loading the view.
}

- (void)initBottomView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.height.mas_offset(44);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGB(204, 204, 204);
    [bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_offset(0.5);
    }];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = RGB(204, 204, 204);
    [bottomView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(0.5);
        make.height.mas_offset(30);
        make.center.equalTo(bottomView);
    }];
    
    for (int i = 0; i < 2; i++) {
        LeftImageRightLabel *button = [LeftImageRightLabel new];
        button.tag = 10 + i;
        button.label.textColor = UIColorFromRGB(0x333333);
        [bottomView addSubview:button];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [button addGestureRecognizer:tap];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
        }];
        switch (i) {
            case 0:
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_offset(-SCREEN_WIDTH / 4);
                }];
                if (self.dynamics.is_supported_flag) {
                    [button initWithData:@"取消" image:[UIImage imageNamed:@"red_like"]];
                } else {
                    [button initWithData:@"赞" image:[UIImage imageNamed:@"gray_like"]];
                }
                break;
            case 1:
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_offset(SCREEN_WIDTH / 4);
                }];
                [button initWithData:@"评论" image:[UIImage imageNamed:@"zhuiwen"]];
                break;
            default:
                break;
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 10) {
        
        // 默认操作是赞
        NSString *action = @"0";
        if (self.dynamics.is_supported_flag) {
            action = @"1";
        }
        // 赞，取消赞
        [ChatDataHelper addSupportType:@"0" typeId:self.dynamics.dynamicId del:action success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                LeftImageRightLabel *view = (LeftImageRightLabel *)tap.view;
                if ([action isEqualToString:@"0"]) {
                    self.dynamics.is_supported_flag = YES;
                    [view initWithData:@"取消" image:[UIImage imageNamed:@"red_like"]];
                    self.dynamics.support_num ++;
                } else {
                    self.dynamics.is_supported_flag = NO;
                    [view initWithData:@"赞" image:[UIImage imageNamed:@"gray_like"]];
                    self.dynamics.support_num --;
                }
                [_tableView reloadData];

            } else {
                [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];
            }
        } fail:^(NSError *error) {
            
        }];
    } else {
        _commentType = 0;
        [self showToolBar:@"评论"];
    }
}

- (void)addCommentView {
    [self.view addSubview:self.chatToolBar];
    self.chatToolBar.hidden = YES;
    [_chatToolBar.faceButton setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateNormal];
    [_chatToolBar.faceButton setImage:[UIImage imageNamed:@"btn_face"] forState:UIControlStateHighlighted];
    [_chatToolBar.moreButton setImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateNormal];
    [_chatToolBar.moreButton setImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateHighlighted];
    
    _chatToolBar.moreButton.width += 10;
    _chatToolBar.moreButton.left -= 10;
    _chatToolBar.styleChangeButton.hidden = YES;
    _chatToolBar.faceButton.frame = _chatToolBar.styleChangeButton.frame;
    _chatToolBar.inputTextView.width += 30;
    [_chatToolBar.inputTextView setReturnKeyType:UIReturnKeyDefault];
    [_chatToolBar.moreButton removeTarget:_chatToolBar action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_chatToolBar.moreButton addTarget:self action:@selector(sendContent:) forControlEvents:UIControlEventTouchUpInside];
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        _chatToolBar.isNeedReturn = YES;
    }
    return _chatToolBar;
}

#pragma mark - DXMessageToolBarDelegate

- (void)didSendText:(NSString *)text {
    [self sendContent:nil];
}

- (void)sendContent:(UIButton *)button {
    if (self.chatToolBar.inputTextView.text.length > 0) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *pid;
        NSString *puid;
        if (_commentType == 1) {
            pid = _currentComment.cid;
            puid = _currentUser.uid;
        }
        [ChatDataHelper addCommentWithContent:self.chatToolBar.inputTextView.text type:@"0" typeId:self.dynamics.dynamicId pid:pid puid:puid at_ids:nil success:^(id responseObject) {
            ErrorModel *model = responseObject;
            if (model.error_code == 0) {
                [self getDataFromServer:YES];
                self.chatToolBar.inputTextView.text = @"";
                [self.view makeToast:@"操作成功" duration:1.0 position:@"bottom"];

                if (_commentType == 0) {
                    self.dynamics.comments_num ++;
                    [_tableView reloadData];
                }
            } else {
                [self.view makeToast:model.error_msg duration:1.0 position:@"bottom"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } fail:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    [self hideToolBar];
}

- (void)showToolBar:(NSString *)placeHolder {
    _chatToolBar.hidden = NO;
    _chatToolBar.inputTextView.placeHolder = placeHolder;
    [_chatToolBar.inputTextView becomeFirstResponder];
}

- (void)hideToolBar {
    _chatToolBar.hidden = YES;
    [_chatToolBar.inputTextView resignFirstResponder];
}


- (void)getDataFromServer:(BOOL)isRefresh {
    
//    WS(weakSelf);
    
    NSString *tempId = @"0";
//    CommentObject *tempDynamics;
//    if (_dataArray.count > 0) {
//        if (isRefresh) {
//            tempDynamics = _dataArray[0];
//        } else {
//            tempDynamics = _dataArray.lastObject;
//        }
//        tempId = tempDynamics.cid;
//        
//    } else {
//        tempId = @"0";
//    }
    [ChatDataHelper getCommentListType:@"0" typeId:self.dynamics.dynamicId curId:tempId num:20 newer:isRefresh success:^(id responseObject) {
        DynamicsCommentModel  *model = responseObject;
        if (model.error_code == 0) {
            
            if (isRefresh) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:model.comments];
            }
            /*
            if (isRefresh) {
                if (_dataArray.count == 0) {
                    [_dataArray addObjectsFromArray:model.comments];
                    
                } else {
                    int number = (int)model.comments.count - 1;
                    for (int i = number; i >= 0; i--) {
                        [_dataArray insertObject:model.comments[i] atIndex:0];
                    }
                }
                
            } else {
                [_dataArray addObjectsFromArray:model.comments];
            }
            
            if (!_tableView.footer) {
                [_tableView addLegendFooterWithRefreshingBlock:^{
                    [weakSelf getDataFromServer:NO];
                }];
            }
            */
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Dynamics *model = self.dynamics;
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
    } else {
        
        _commentCell.comment = _dataArray[indexPath.row];
        CGSize size = [_commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        Dynamics *model = self.dynamics;
        
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
    } else {
        DynamicCommentCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"DynamicCommentCell" forIndexPath:indexPath];
        cell.comment = _dataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideToolBar];
}

#pragma mark DynamicCommentCellDelegate
- (void)clickReplay:(CommentObject *)comment toUser:(User *)user {
    _currentComment = comment;
    _currentUser = user;
    _commentType = 1;
    [self showToolBar:[NSString stringWithFormat:@"回复：%@", user.name]];
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
