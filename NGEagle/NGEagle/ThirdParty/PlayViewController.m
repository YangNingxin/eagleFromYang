//
//  PlayViewController.m
//  Eagle
//
//  Created by 张伊辉 on 14-2-24.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "PlayViewController.h"
#import "SVProgressHUD.h"
#import "FCFileManager.h"
#import "NSString+Hashing.h"
#import "DownLoadHelper.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addPlayView:(NSURL *)localURL {
 
    self.player = [[MPMoviePlayerController alloc]initWithContentURL:localURL];
    self.player.view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.player.view.backgroundColor=[UIColor clearColor];
    [self.player setMovieSourceType:MPMovieSourceTypeFile];
    [self.view addSubview:self.player.view];
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.player];
}

- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"播放视频";

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_custom"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    if (self.fileURL) {
        [self addPlayView:self.fileURL];
        return;
    }
    NSString *md5Url = [NSString stringWithFormat:@"%@.mp4", [self.url MD5Hash]];
    NSString *filePath = [FCFileManager pathForCachesDirectoryWithPath:md5Url];
    self.fileURL = [NSURL fileURLWithPath:filePath];

    if ([FCFileManager existsItemAtPath:filePath]) {
        [self addPlayView:self.fileURL];
    } else {
        [SVProgressHUD showWithStatus:@"正在下载" maskType:SVProgressHUDMaskTypeClear];
        [DownLoadHelper downLoadFileWithURL:self.url saveFilePath:filePath backBlock:^(int status) {
            if (status == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"下载完成"];
                [self addPlayView:self.fileURL];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"下载失败"];
            }
        }];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction {
    
    [self.player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
