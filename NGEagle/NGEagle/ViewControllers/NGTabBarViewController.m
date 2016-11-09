//
//  NGTabBarViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NGTabBarViewController.h"
#import "MainPageViewController.h"
#import "StudyCircleViewController.h"
#import "FindViewController.h"
#import "MineViewController.h"
#import "CCTaskViewController.h"
#import "CCAddViewController.h"
#import "ToolMenuView.h"
#import "CCPublishViewController.h"
#import "UIImageUtil.h"
#import "QRCodeReaderViewController.h"
#import "QrResultViewController.h"
#import "AddDynamicViewController.h"
#import "Account.h"
#import "CreateQuestionViewController.h"

@interface NGTabBarViewController () <ToolMenuViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UINavigationController *mainNav;
    UINavigationController *taskNav;
    UINavigationController *studyNav;
    UINavigationController *findNav;
    UINavigationController *addNav;
    
    ToolMenuView *menuView;
}
@end

@implementation NGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 初始化模块控制器
    [self initBaseViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMessageNumber:) name:@"showMessageNumber" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCourseMsgNumber:) name:@"showCourseMsgNumber" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)showMessageNumber:(NSNotification *)note {
    
    if ([note.object isEqualToString:@"0"]) {
        studyNav.tabBarItem.badgeValue = nil;
        
    } else {
        studyNav.tabBarItem.badgeValue = note.object;
    }    
}

- (void)showCourseMsgNumber:(NSNotification *)note {
    if ([note.object isEqualToString:@"0"]) {

    } else {

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark ToolMenuView
- (void)clickMenu:(int)index {
    [menuView removeFromSuperview];
    menuView = nil;
    
    UINavigationController *nav = (UINavigationController *)self.viewControllers[self.selectedIndex];
    
    if (index == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的设备不支持拍照!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else if (index == 1) {
        NSArray *types = @[AVMetadataObjectTypeQRCode];
        QRCodeReaderViewController *_reader = [QRCodeReaderViewController readerWithMetadataObjectTypes:types];
        
        // Or by using blocks
        [_reader setCompletionWithBlock:^(NSString *resultAsString) {
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"%@", resultAsString);
                if (resultAsString) {
                    QrResultViewController *vc = [[QrResultViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.url = resultAsString;
                    [nav pushViewController:vc animated:YES];
                }
            }];
        }];
        
        [self presentViewController:_reader animated:YES completion:NULL];
    } else if (index == 2) {
        
        CreateQuestionViewController *publishVc = [[CreateQuestionViewController alloc] init];
        publishVc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:publishVc animated:YES];
    }
}

-(void)initBaseViewControllers {
    MainPageViewController *mainVc = [[MainPageViewController alloc] init];
    mainNav = [[UINavigationController alloc] initWithRootViewController:mainVc];
    mainNav.navigationBarHidden = YES;
    NSString *url = [NSString stringWithFormat:@"%@%@", [Account shareManager].server, kApiShouYeH5];
    mainVc.url = url;
    mainNav.tabBarItem.image = [[UIImage imageNamed:@"tab_xuetang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_xuetang_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mainNav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

    CCTaskViewController *taskVc = [[CCTaskViewController alloc] init];
    taskNav = [[UINavigationController alloc] initWithRootViewController:taskVc];
    taskNav.navigationBarHidden = YES;
    taskNav.tabBarItem.image = [[UIImage imageNamed:@"tab_work"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    taskNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_work_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [taskNav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

    
    CCAddViewController *addVc = [[CCAddViewController alloc] init];
    addNav = [[UINavigationController alloc] initWithRootViewController:addVc];
    addNav.navigationBarHidden = YES;
    addNav.tabBarItem.image = [[UIImage imageNamed:@"tab_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [addNav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

    
    StudyCircleViewController *studyVc = [[StudyCircleViewController alloc] initWithNibName:@"StudyCircleViewController" bundle:nil];
    studyNav = [[UINavigationController alloc] initWithRootViewController:studyVc];
    studyNav.navigationBarHidden = YES;
    studyNav.tabBarItem.image = [[UIImage imageNamed:@"tab_xuexiquan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    studyNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_xuexiquan_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [studyNav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

    
    FindViewController *findVc = [[FindViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    findNav = [[UINavigationController alloc] initWithRootViewController:findVc];
    findNav.navigationBarHidden = YES;
    NSString *url2 = [NSString stringWithFormat:@"%@%@", @"xxx", KFindURL];
    findVc.url = url2;
    findNav.tabBarItem.image = [[UIImage imageNamed:@"tab_find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_find_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [findNav.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

    NSArray *viewControllers = @[mainNav, addNav, studyNav];
    [self setViewControllers:viewControllers];
}

// 自定义tabbarcontroller,需要实现以下方法。

-(void)viewWillAppear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition:YES animated: animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == addNav) {
        
        menuView = [ToolMenuView new];
        menuView.delegate = self;
        [self.view addSubview:menuView];
        
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        return  NO;
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)dealloc {
    
    mainNav = nil;
    studyNav = nil;
    findNav = nil;
    addNav = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark
#pragma mark photoes
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [UIImageUtil thumbnailWithImage:image];
        
        
    }
    UINavigationController *nav = (UINavigationController *)self.viewControllers[self.selectedIndex];

    [picker dismissViewControllerAnimated:YES completion:^{
        
        // 初始化文件字典
        NSMutableDictionary *fileDict = [NSMutableDictionary new];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [fileDict setObject:imageArray forKey:@"data"];
        [fileDict setObject:@"0" forKey:@"type"];
        
        [[fileDict objectForKey:@"data"] addObject:image];
        
        AddDynamicViewController *addvc = [[AddDynamicViewController alloc] init];
        addvc.fileDict = fileDict;
        addvc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:addvc animated:YES];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
