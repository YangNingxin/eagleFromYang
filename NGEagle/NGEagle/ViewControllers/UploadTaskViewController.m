//
//  UploadTaskViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/11.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "UploadTaskViewController.h"
#import "PhotoListViewController.h"
#import "UIImageUtil.h"
#import "EGMergeVideoAndAudio.h"
#import "ErrorModel.h"
#import "ImageModel.h"
#import "BrowsePicturesViewController.h"

@interface UploadTaskViewController ()
{
    /**
     *  0图片，1视频
     */
    int _type;
    BOOL isFirstIn;
}
@end

@implementation UploadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstIn = YES;
    self.addButton.frame = CGRectMake(AutoSize(10), AutoSize(10), AutoSize(95), AutoSize(95));

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSelectImage:) name:@"finishSelectImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteResourceAction:) name:@"deleteResourceAction" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)configBaseUI {
    [super configBaseUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"提交任务";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
    
}

- (void)rightButtonAction {
    
    if (self.textView.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSString *resource_type = @"image";
    if (_type == 1) {
        resource_type = @"video";
    }
    
    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
 
    int uid = [[Account shareManager].userModel.user.uid intValue];
    
    [DataHelper submitTaskAnswerWithTaskID:self.taskId author_uid:uid content:self.textView.text resource_type:resource_type file:self.fileDict openclass_id:self.openclass_id success:^(id responseObject) {
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadTaskFinished" object:nil userInfo:@{ @"task_id":@(self.taskId), @"error_code":@(0)} ];
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络服务器异常！请重试"];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (isFirstIn) {
        [self.textView becomeFirstResponder];
        isFirstIn = NO;
    }
}

- (void)finishSelectImage:(NSNotification *)note {
    self.fileDict = note.object;
    [self addImages];
}

- (void)deleteResourceAction:(NSNotification *)note {
    int index = [[note object] intValue];
    [self.fileDict[@"data"] removeObjectAtIndex:index];
    [self addImages];
}

/**
 *  添加图片
 */
- (void)addImages {
    
    @autoreleasepool {
        for (UIView *v in self.contentView.subviews) {
            if (v.tag >= 100) {
                [v removeFromSuperview];
            }
        }
    }
    
    NSArray *array = self.fileDict[@"data"];
    
    for (int i = 0; i < array.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(AutoSize(10) + i%3 * AutoSize(100), AutoSize(10) + i/3 * AutoSize(100), AutoSize(95), AutoSize(95))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = array[i];
        imageView.tag = 100 + i;
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
    }
    
    int i = (int)array.count;
    self.addButton.frame = CGRectMake(AutoSize(10) + i%3 * AutoSize(100), AutoSize(10) + i/3 * AutoSize(100), AutoSize(95), AutoSize(95));
    if (array.count == 9) {
        self.addButton.hidden = YES;
    }
    NSLog(@"self.filedict is %@", self.fileDict);
}

- (void)imageAction:(UITapGestureRecognizer *)tap {
    
    NSArray *array = self.fileDict[@"data"];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    int index = 0;
    for (UIImage *image in array) {
        
        ImageModel *model = [[ImageModel alloc] init];
        model.imageId = index;
        model.image = image;
        model.width = image.size.width;
        model.height = image.size.height;
        [imageArray addObject:model];
        
        index ++;
    }
    
    BrowsePicturesViewController *browseVc = [[BrowsePicturesViewController alloc] init];
    browseVc.imagesArray = imageArray;
    browseVc.index = tap.view.tag - 100;
    [self presentViewController:browseVc animated:YES completion:nil];    
}

/**
 *  添加视频
 */
- (void)addVideo {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(AutoSize(10), AutoSize(10), AutoSize(95), AutoSize(95))];
    imageView.image = [UIImage imageNamed:@"default_video"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.addButton.hidden = YES;
}

- (IBAction)addButtonAction:(UIButton *)button {
    
    [self.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"视频", @"拍照",@"相册", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 选择的是照片列表
    if (buttonIndex == 2) {
        
        PhotoListViewController *photoListVc =
        [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
        photoListVc.fileDict = self.fileDict;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoListVc];
        [self presentViewController:nav animated:YES completion:nil];
        _type = 0;
        
    } else {
        
        // 如果有数据，并且类型是图片
        if (self.fileDict) {
            
            // 照片
            if ([[self.fileDict objectForKey:@"type"] intValue] == 0) {
                if (buttonIndex == 0) {
                    
                    // 点击视频直接返回
                    return;
                }
            }
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            if (buttonIndex == 1) { // 拍照
                
                [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                _type = 0;
            } else { // 拍视频
                
                [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeMedium];
                imagePicker.videoMaximumDuration = 19;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
                _type = 1;
            }
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark
#pragma mark photoes
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        
    if (!self.fileDict) {
        self.fileDict = [NSMutableDictionary dictionary];
        NSMutableArray *imageArray = [NSMutableArray array];
        [self.fileDict setObject:imageArray forKey:@"data"];
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [UIImageUtil thumbnailWithImage:image];
        
        [self.fileDict setObject:@"0" forKey:@"type"];
        [[self.fileDict objectForKey:@"data"] addObject:image];
        
        [self addImages];
        
    } else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self.fileDict setObject:@"1" forKey:@"type"];
        [self.fileDict setObject:videoURL forKey:@"data"];
        
        [self addVideo];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
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
