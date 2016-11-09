//
//  CourseDetailViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseModel.h"
#import "ClassListViewController.h"
#import "ClassDetailViewController.h"
#import "CommentListViewController.h"
#import "BdLocationViewController.h"
#import "OrganizationViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UploadTaskViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "SelectClassViewController.h"

@interface CourseDetailViewController () <UMSocialUIDelegate>
{
    BOOL isQQInstalled;
    BOOL isWeixinInstalled;
}
@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    
    isQQInstalled = [QQApiInterface isQQInstalled];
    isWeixinInstalled = [WXApi isWXAppInstalled];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadTaskFinished:)
                                                 name:@"uploadTaskFinished" object:nil];
    
    _request = [DataHelper getCourseAppointmentInfo:self.cid success:^(id responseObject) {
        _courseDetail = ((CourseDetailModel *)responseObject).data;
        [self setContentUI];
        
    } fail:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Account shareManager].messageNumber.course.countNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCourseMsgNumber" object:@"0"];
}

- (void)rightButtonAction {
    if (isWeixinInstalled) {
        [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:_courseDetail.url];

    }
    if (isQQInstalled) {
        [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPSECRET url:_courseDetail.url];
    }
    NSString *text = [NSString stringWithFormat:@"【%@】%@", _courseDetail.name, _courseDetail.desc];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:text
                                     shareImage:[UIImage imageNamed:@"icon_share"]
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone]
                                       delegate:self];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)setContentUI {
    
    self.contentLabel.text = _courseDetail.tip;
    
    [self.contentButton setTitle:_courseDetail.button_info forState:UIControlStateNormal];
    if (_courseDetail.status == 3) { // 不可预约
        [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_no"] forState:UIControlStateNormal];
        self.contentButton.enabled = NO;
    } else {
        [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_course"] forState:UIControlStateNormal];
        self.contentButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBaseUI {
    
    [super configBaseUI];
    
    [_rightButotn setTitle:@"分享" forState:UIControlStateNormal];
    self.bottomView.top = SCREEN_HEIGHT - 44;
    self.bottomView.backgroundColor = RGB(228, 228, 228);
    [self.view addSubview:self.bottomView];
    
    self.webview.height -= 44;
    
    
    if (!isQQInstalled && !isWeixinInstalled) {
        _rightButotn.hidden = YES;
    }
}


- (IBAction)contentButtonAction:(UIButton *)button {
    
    if (_courseDetail) {
        if (_courseDetail.status == 1) {
            
            ClassListViewController *classVc = [[ClassListViewController alloc] initWithNibName:@"ClassListViewController" bundle:nil];
            classVc.course_id = self.cid;
            [self.navigationController pushViewController:classVc animated:YES];
            
        } else if (_courseDetail.status == 2) {
            //2--已经预约当前课程，且预约的班级还没有上完，不能再预约，点击按钮到所预约班次的详情页
            
            ClassDetailViewController *webVc = [[ClassDetailViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            webVc.webTitle = @"班次详情";
            webVc.url = _courseDetail.class_detail_url;
            webVc.webType = CLASS_DETAIL;
            webVc.cid = _courseDetail.appoint_class_id;
            [self.navigationController pushViewController:webVc animated:YES];
            
        }
    }
}

- (void)praseDict:(NSDictionary *)dict type:(int)type {
    [super praseDict:dict type:type];
    
    if (type == 6) {
        OrganizationViewController *organizationVc = [[OrganizationViewController alloc] init];
        organizationVc.url = dict[@"url"];
        organizationVc.name = dict[@"name"];
        organizationVc.is_follow = [dict[@"is_follow"] boolValue];
        organizationVc.organizationId = [dict[@"school_id"] intValue];
        [self.navigationController pushViewController:organizationVc animated:YES];
        
    } else if (type == 7) {
        
        ClassListViewController *classVc = [[ClassListViewController alloc] initWithNibName:@"ClassListViewController" bundle:nil];
        classVc.course_id = self.cid;
        [self.navigationController pushViewController:classVc animated:YES];
        
    } else if (type == 8) {
        
        //进入评论列表
        CommentListViewController *listVc = [[CommentListViewController alloc] initWithNibName:@"CommentListViewController" bundle:nil];
        listVc.cid = self.cid;
        [self.navigationController pushViewController:listVc animated:YES];

    } else if (type == 9) {
        
        BdLocationViewController *locationVc = [[BdLocationViewController alloc] init];
        locationVc.name = dict[@"name"];
        float lat = [dict[@"latitude"] floatValue];
        float lon = [dict[@"longitude"] floatValue];
        locationVc.cooridinate = CLLocationCoordinate2DMake(lat, lon);
        [self.navigationController pushViewController:locationVc animated:YES];

    } else if (type == 11) {
        
        /*
         调整了提交任务单的接口，增加了openclass_id参数，新提交的覆盖之前的
         */
        int task_id = [dict[@"task_id"] intValue];
        UploadTaskViewController *uploadVc = [[UploadTaskViewController alloc] initWithNibName:@"UploadTaskViewController" bundle:nil];
        uploadVc.openclass_id = _courseDetail.appoint_class_id;
        uploadVc.taskId = task_id;
        [self.navigationController pushViewController:uploadVc animated:YES];

    } else if (type == 0) {
        
        /*
         title = "\U4efb\U52a1\U5355\U8be6\U60c5";
         type = 0;
         url = "http://117.121.26.76/index.php?app=webapp&mod=Opencourse&act=showTaskAnswer&task_id=64";
         */
        
        WebViewController *webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webView.url = dict[@"url"];
        webView.webTitle = dict[@"title"];
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if (type == 12) {
        /*
         课程详情页增加schema：params: {"type":12,"task_id":1}
         老师打开课程详情页，查看任务单列表，如果是任课老师，可点击“查看任务”，跳转到发布该任务的班次列表页
         */
        SelectClassViewController *selectVc = [[SelectClassViewController alloc]
                                               initWithNibName:@"SelectClassViewController" bundle:nil];
        selectVc.taskId = [dict[@"task_id"] intValue];
        [self.navigationController pushViewController:selectVc animated:YES];

    }
}

- (void)uploadTaskFinished:(NSNotification *)aNote {
    
    NSDictionary *dict = aNote.userInfo;
    NSString *jsCode = [NSString stringWithFormat:@"course_basic.modifyTaskStatus(%@, %@);",
                        dict[@"task_id"], dict[@"error_code"]];
    [self.webview stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
