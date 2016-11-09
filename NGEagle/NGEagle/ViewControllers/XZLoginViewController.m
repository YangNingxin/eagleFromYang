//
//  XZLoginViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/24.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "XZLoginViewController.h"
#import "NumberSchoolDataHelper.h"
#import "AppDelegate.h"
#import "UserDao.h"
#import "TMCache.h"
#import "BindPhoneViewController.h"

@interface XZLoginViewController ()
{
    AccessToken *tokenObject;
}
@end

@implementation XZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    self.url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@",
                _otherLogin.auth_url, _otherLogin.client_id, NS_Redirect_Uri, _otherLogin.scope];
    self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"self.url is %@", self.url);
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)configBaseUI {
    [super configBaseUI];
    
    _titleLabel.text = @"数字学校登录";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    NSURL *url = [request URL];
    NSString *urlString = url.absoluteString;
    
    if ([urlString hasPrefix:NS_Redirect_Uri]) {
        NSString *query = url.query;
        NSArray *params = [query componentsSeparatedByString:@"="];
        if (params.count > 1) {
            NSString *code = params[1];
            [self getAccessTokenWithCode:code];
            return  NO;
        }
        NSLog(@"query is %@", query);
    }
    NSLog(@"url is %@", url);
    return YES;
}

- (void)getAccessTokenWithCode:(NSString *)code {
    
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
    
    [NumberSchoolDataHelper getNSAccessTokenByCode:code client_id:_otherLogin.client_id client_secret:_otherLogin.client_secret grant_type:@"authorization_code" redirect_uri:NS_Redirect_Uri state:@"学乎" serverURL:_otherLogin.token_url success:^(id responseObject) {
       
        // 得到第三方token
        tokenObject = responseObject;
        
        if (tokenObject.access_token && tokenObject.userid) {
            
            [NumberSchoolDataHelper loginByOtherToken:tokenObject.access_token node_id:_otherLogin.node_id success:^(id responseObject) {
                UserModel *userModel = responseObject;
                if (userModel.error_code == 0 && userModel.token.length) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    
                    [self loginSuccessByUserModel:userModel];
                    
                    NSLog(@"userModel %@", userModel);
                } else {
                    
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }
                
            } fail:^(NSError *error) {
                
                [SVProgressHUD showErrorWithStatus:@"登录失败"];

            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
    } fail:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

- (void)loginSuccessByUserModel:(UserModel *)userModel {
    
    if (userModel && userModel.error_code == 0 && userModel.user && userModel.user.uid) {
        
        // 第三方登录
        userModel.user.login_type = 100;
        userModel.user.username = tokenObject.access_token;
        
        // 把登录用户存入数据库
        [[DBManager shareManager] openDataBase];
        [UserDao createUser];
        [UserDao insertUser:userModel.user];
        
        // 通过Account账号单例，存储登录信息
        [Account shareManager].userModel = userModel;
        
        // 缓存登录信息到本地，加密过的
        [[TMCache sharedCache] setObject:userModel forKey:@"userModel"];
        
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userModel.user.uid password:HXDefaultPassword completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error && loginInfo) {
                
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                
                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                [options setDisplayStyle:ePushNotificationDisplayStyle_messageSummary];
                [options setNickname:userModel.user.nick];
                [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
                
                NSLog(@"环信=====================登陆成功");
            }
        } onQueue:nil];
        
        if (userModel.user.telephone.length > 0) {
            
            // 登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(0)];
            
            // 标记登录成功
            [[Account shareManager] setIsLogined:YES];
            
        } else {
            
            BindPhoneViewController *bindPhoneVc = [[BindPhoneViewController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
            bindPhoneVc.register_flag = YES;
            bindPhoneVc.isNumberSchool = YES;
            [self.navigationController pushViewController:bindPhoneVc animated:YES];
        }
    } else {
        
        // 登录失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                        message:userModel.error_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
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
