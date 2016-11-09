//
//  CCCourseDetailController.m
//  NGEagle
//
//  Created by Liang on 16/4/7.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCCourseDetailController.h"
#import "DXMessageToolBar.h"
#import "IQKeyboardManager.h"
#import "ShareView.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "CourseHelper.h"
#import "CCPublishViewController.h"
#import "AddNoteViewController.h"
#import "CreateQuestionViewController.h"
#import "ReportViewController.h"
#import "AddCommentSuccess.h"
#import "Account.h"
#import "PersonPageViewController.h"
#import "QuestionDetailController.h"
#import "CreateAnswerViewController.h"

@interface CCCourseDetailController () <DXMessageToolBarDelegate, UIActionSheetDelegate>
{
    /**
     *  0为评论，1为回复
     */
    int _commentType;
    // 数据
    NSDictionary *htmlDict;
}
@property (nonatomic, strong) DXMessageToolBar *chatToolBar;
@end

@implementation CCCourseDetailController

- (void)viewDidLoad {
    
    // 如果有课程model
    if (self.course) {
        self.obj_type_id = self.course.obj_type_id;
        self.url = self.course.webapp_url;
        self.courseId = self.course.cid;
    }
    [super viewDidLoad];
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_offset(-50);
        make.top.mas_equalTo(64);
    }];
    
    [self addBottomBar];
    [self addCommentView];
    
    // Do any additional setup after loading the view.
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // 去掉keyboard效果
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 去掉keyboard效果
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)configBaseUI {

    [super configBaseUI];
    _titleLabel.text = @"课程详情";
    [_rightButotn setImage:[UIImage imageNamed:@"icon_menu_more"] forState:UIControlStateNormal];
    _rightButotn.hidden = NO;
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

- (void)addBottomBar {
    
    NSArray *items = @[
                       @{
                         @"image":@"btn_comment",
                         @"image_sel":@"btn_comment_sel"},
                       @{
                           @"image":@"btn_tiwen",
                           @"image_sel":@"btn_tiwen_sel"},
                       @{
                           @"image":@"btn_biji",
                           @"image_sel":@"btn_biji_sel"},
                       ];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIView *_lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB(204, 204, 204);
    [bottomView addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    for (int i = 0; i < items.count; i++) {
        
        NSDictionary *dict = items[i];
        
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:dict[@"image"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:dict[@"image_sel"]] forState:UIControlStateHighlighted];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        switch (i) {
            case 0:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bottomView);
                    make.centerX.mas_equalTo(-110);
                }];
            }
                break;
            case 1:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bottomView);
                    make.centerX.mas_equalTo(0);
                }];
            }
                break;
            case 2:
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bottomView);
                    make.centerX.mas_equalTo(110);
                }];

            }
                break;
            default:
                break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonAction {
    
    [self hideToolBar];
    
    WS(weakSelf);
    
    ShareView *shareView = [[ShareView alloc] init];
    [shareView setClickEventBlock:^(int index) {
        if (index == 6) {
            [self gotoReport:3 targetId:weakSelf.courseId];
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

// 操作事件
- (void)handleAction:(UIButton *)button {
    switch (button.tag) {
        case 200:
            [self showToolBar];
            break;
        case 201:
        {
            [self gotoCreateQuestion:-1 isAppendAsk:NO answerId:-1];
        }
            break;
        case 202:
        {
            NSString *result = [self.webview stringByEvaluatingJavaScriptFromString:@"get_video_time('0');"];
            NSDictionary *dict = [CCJsonKit getObjectFromJsonString:result];
            int mark_at = [dict[@"time"] intValue];
            
            AddNoteViewController *addNoteVc = [[AddNoteViewController alloc] init];
            if (self.obj_type_id == 502) {
                addNoteVc.type = 2;
            } else {
                addNoteVc.type = 1;
            }
            addNoteVc.target_id = self.courseId;
            addNoteVc.mark_at = mark_at;
            [addNoteVc setAddNoteSuccessBlock:^(AddNoteSuccess *model) {
                
                // 刷新js，添加笔记
                NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                [result setObject:@(model.data.nid) forKey:@"id"];
                [result setObject:[Account shareManager].userModel.user.logo forKey:@"user_logo"];
                [result setObject:[Account shareManager].userModel.user.name forKey:@"user_name"];
                
                [result setObject:model.data.content forKey:@"content"];
                
                NSString *jsonstring = [CCJsonKit getJsonFromDictOrMuArr:result];
                
                // 调用js刷新
                [self.webview stringByEvaluatingJavaScriptFromString:
                 [NSString stringWithFormat:@"add_weike_note(%@)", jsonstring]];
            }];
            [self.navigationController pushViewController:addNoteVc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)showToolBar {
    _chatToolBar.hidden = NO;
    [_chatToolBar.inputTextView becomeFirstResponder];
}

- (void)hideToolBar {
    _chatToolBar.hidden = YES;
    [_chatToolBar.inputTextView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideToolBar];
}

// 去提问页面
- (void)gotoCreateQuestion:(int)mark_at isAppendAsk:(BOOL)isAppendAsk answerId:(int)answerId {
    
    int resultMarkAt = mark_at;
    if (mark_at == -1) {
        NSString *result = [self.webview stringByEvaluatingJavaScriptFromString:@"get_video_time('0');"];
        NSDictionary *dict = [CCJsonKit getObjectFromJsonString:result];
        resultMarkAt = [dict[@"time"] intValue];
    }
    CreateQuestionViewController *publishVc = [[CreateQuestionViewController alloc] init];
    if (self.obj_type_id == 502) {
        publishVc.domain = 4;
    } else {
        publishVc.domain = 2;
    }
    publishVc.closely_answer_id = answerId;
    publishVc.target_id = self.courseId;
    publishVc.mark_at = resultMarkAt;
    [publishVc setCreateQuestionSuccess:^(CreateQuestionModel *model) {
        // 刷新js，添加提问
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setObject:@(model.data.qid) forKey:@"id"];
        [result setObject:[Account shareManager].userModel.user.logo forKey:@"user_logo"];
        [result setObject:[Account shareManager].userModel.user.name forKey:@"user_name"];
        
        if (model.data.type == 1) {
            [result setObject:model.data.arrayData forKey:@"images"];
        } else if (model.data.type == 2) {
            [result setObject:model.data.arrayData forKey:@"videos"];
        } else if (model.data.type == 3) {
            [result setObject:model.data.arrayData forKey:@"audios"];
        }
        [result setObject:model.data.content forKey:@"content"];
        
        NSString *jsonstring = [CCJsonKit getJsonFromDictOrMuArr:result];
        
        // 调用js刷新
        [self.webview stringByEvaluatingJavaScriptFromString:
         [NSString stringWithFormat:@"add_weike_question(%@)", jsonstring]];
    }];
    [self.navigationController pushViewController:publishVc animated:YES];
}

// 去举报
- (void)gotoReport:(int)type targetId:(int)targetId {
    
    ReportViewController *reportVc = [[ReportViewController alloc] init];
    reportVc.type = type;
    reportVc.target_id = targetId;
    [self.navigationController pushViewController:reportVc animated:YES];
}

// 解析webView
- (void)praseDict:(NSDictionary *)dict type:(int)type {
    [super praseDict:dict type:type];
    
    htmlDict = dict;
    if (type == 6) {
        // 课程集的播放
        CCBaseWebController *webVc = [[CCBaseWebController alloc] init];
        webVc.url = dict[@"resource_url"];
        [self.navigationController pushViewController:webVc animated:YES];
        
    } else if (type == 7) { // 问答详情页的追问操作
        int answer_id = [dict[@"answer_id"] intValue];
        [self gotoCreateQuestion:-1 isAppendAsk:YES answerId:answer_id];
    } else if (type == 8) {
        
        BOOL self_flag = [dict[@"self_flag"] boolValue];
        NSString *button1 = [NSString stringWithFormat:@"在课程第%@提问", dict[@"format_mark_at"]];
        if (!self_flag) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:button1, @"查看详情", @"回答问题", @"举报", nil];
            sheet.tag = 2;
            [sheet showInView:self.view];
        } else {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:button1, @"查看详情", @"举报", nil];
            sheet.tag = 2;
            [sheet showInView:self.view];
        }
       
    } else if (type == 11) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", @"查看个人主页", @"举报", nil];
        sheet.tag = 1;
        [sheet showInView:self.view];
    }
   
}

#pragma mark
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    WS(weakSelf);
    // 评论
    if (actionSheet.tag == 1) {
        
        switch (buttonIndex) {
            case 0:
            {
                _commentType = 1;
                [self showToolBar];
            }
                break;
            case 1:
            {
                PersonPageViewController *vc = [[PersonPageViewController alloc] init];
                vc.url = htmlDict[@"user_homepage_url"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                [self gotoReport:3 targetId:weakSelf.courseId];
            }
                break;
            default:
                break;
        }
    } else if (actionSheet.tag == 2) { // 提问
        
        BOOL self_flag = [htmlDict[@"self_flag"] boolValue];
        int question_id = [htmlDict[@"question_id"] intValue];

        switch (buttonIndex) {
            case 0:
            {
                [self gotoCreateQuestion:[htmlDict[@"time"] intValue] isAppendAsk:NO answerId:-1];
            }
                break;
            case 1:
            {
                QuestionDetailController *questionVc = [[QuestionDetailController alloc] init];
                questionVc.questionId = question_id;
                [self.navigationController pushViewController:questionVc animated:YES];
                
            }
                break;
            case 2:
            {
                if (self_flag) {
                    // 举报
                    [self gotoReport:8 targetId:question_id];
                } else {
                    // 回答问题
                    {
                        CreateAnswerViewController *createVc = [[CreateAnswerViewController alloc] init];
                        createVc.question_id = question_id;
                        [createVc setCreateAnswerSuccess:^(CreateAnswerModel *model) {
                            // 刷新js，添加提问
                            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                            [result setObject:@(model.data.qid) forKey:@"id"];
                            [result setObject:[Account shareManager].userModel.user.logo forKey:@"user_logo"];
                            [result setObject:[Account shareManager].userModel.user.name forKey:@"user_name"];
                            
                            if (model.data.type == 1) {
                                [result setObject:model.data.arrayData forKey:@"images"];
                            } else if (model.data.type == 2) {
                                [result setObject:model.data.arrayData forKey:@"videos"];
                            } else if (model.data.type == 3) {
                                [result setObject:model.data.arrayData forKey:@"audios"];
                            }
                            [result setObject:model.data.content forKey:@"content"];
                            
                            NSString *jsonstring = [CCJsonKit getJsonFromDictOrMuArr:result];
                            
                            // 调用js刷新
                            [self.webview stringByEvaluatingJavaScriptFromString:
                             [NSString stringWithFormat:@"add_weike_answer(%@)", jsonstring]];
                        }];
                        [self.navigationController pushViewController:createVc animated:YES];
                    }

                }
            }
                break;
            case 3:
            {
                if (!self_flag) {
                    // 举报
                    [self gotoReport:8 targetId:question_id];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - DXMessageToolBarDelegate

- (void)didSendText:(NSString *)text {
    [self sendContent:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    
}

- (void)sendContent:(UIButton *)button {
    if (self.chatToolBar.inputTextView.text.length > 0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        int pid = 0;
        int puid = 0;
        // 如果是回复
        if (_commentType == 1) {
            pid = [htmlDict[@"comment_id"] intValue];
            puid = [htmlDict[@"user_id"] intValue];
        }
        
        int type = 5;
        if (self.obj_type_id == 502) {
            type = 6; // 课程集
        }
        NSString *content = self.chatToolBar.inputTextView.text;
        [CourseHelper addComment:type typeId:self.courseId content:content pid:pid puid:puid at_ids:nil success:^(id responseObject) {
            
            AddCommentSuccess *model = responseObject;
            if (model.error_code == 0) {

                self.chatToolBar.inputTextView.text = @"";
                [self.view makeToast:@"操作成功" duration:1.0 position:@"bottom"];

                /*
                 id -- 添加评论时返回的id
                 *  user_logo -- 发表评论的用户logo
                 *  user_name -- 发表评论的用户名称
                 *  content -- 评论内容
                 *  pid -- 对于回复时有效, 回传要回复的评论的id
                 */
                NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                [result setObject:@(model.data.cid) forKey:@"id"];
                [result setObject:[Account shareManager].userModel.user.logo forKey:@"user_logo"];
                [result setObject:[Account shareManager].userModel.user.name forKey:@"user_name"];

                [result setObject:content forKey:@"content"];
                [result setObject:@(pid) forKey:@"pid"];

                NSString *jsonstring = [CCJsonKit getJsonFromDictOrMuArr:result];
                
                // 调用js刷新
                [self.webview stringByEvaluatingJavaScriptFromString:
                 [NSString stringWithFormat:@"add_weike_comment(%@)", jsonstring]];
                
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
