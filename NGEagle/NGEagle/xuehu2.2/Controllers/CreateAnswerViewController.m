//
//  CreateQuestionViewController.m
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CreateAnswerViewController.h"
#import "ResourceModel.h"
#import "CourseHelper.h"
#import "CreateQuestionModel.h"
#import "SelectPeopleController.h"
#import "FCFileManager.h"
#import "EMVoiceConverter.h"
#import "CreateAnswerModel.h"

@interface CreateAnswerViewController ()
{
    CreateAnswerSuccess _block;
}
@end

@implementation CreateAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemView1.hidden = YES;
    _textView.placeholder = @"快来说说你的回答吧";

    // Do any additional setup after loading the view.
}

- (void)setCreateAnswerSuccess:(CreateAnswerSuccess)block {
 
    _block = block;
}
- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"我要回答";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonAction {
    
    
    if (_textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在提交..." animated:YES];
    
    int type = [self.fileDict[@"type"] intValue];
    NSArray *images = self.fileDict[@"data"];
    if (type == 0) {
        
        __block int numberImage = 0;
        NSMutableString *imageString = [[NSMutableString alloc] init];
        NSMutableString *md5String = [[NSMutableString alloc] init];
        
        for (int i = 0; i < images.count; i++) {
            NSData *data = UIImagePNGRepresentation(images[i]);
            [DataHelper uploadResource:data file_type:@"image" from:nil use_type:nil success:^(id responseObject) {
                UpLoadResourceModel *tempModel = responseObject;
                if (tempModel.error_code == 0) {
                    Resource *model = tempModel.data[0];
                    numberImage ++;
                    [imageString appendFormat:@"%@,", model.url];
                    [md5String appendFormat:@"%@,", model.md];
                    
                    if (numberImage == images.count) {
                        //所有图片都上传完毕了，可以上传图
                        [self createQuestion:@"image" imageUrl:imageString iamgeMd:md5String videoMd:nil audioMd:nil];
                    }
                } else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.view makeToast:@"上传失败" duration:1.0 position:@"bottom"];
                }
                
            } fail:^(NSError *error) {
                [self.view makeToast:kNetWorkError duration:1.0 position:@"bottom"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }
        
    } else if (type == 1) {
        
        NSData *data = [NSData dataWithContentsOfURL:self.fileDict[@"ext_file"]];
        
        [DataHelper uploadResource:data file_type:@"video" from:nil use_type:nil success:^(id responseObject) {
            UpLoadResourceModel *tempModel = responseObject;
            if (tempModel.error_code == 0) {
                
                Resource *model = tempModel.data[0];
                [self createQuestion:@"video" imageUrl:nil iamgeMd:nil videoMd:model.md audioMd:nil];
                
            } else {
                [self.view makeToast:@"上传失败" duration:1.0 position:@"bottom"];
            }
            
        } fail:^(NSError *error) {
            [self.view makeToast:kNetWorkError duration:1.0 position:@"bottom"];
            
        }];
    } else if (type == 2) {
        
        // 判断临时路径是否存在，如果有，删除掉
        NSString *filePath = [FCFileManager pathForCachesDirectoryWithPath:recordAmrAudioName];
        if ([FCFileManager existsItemAtPath:filePath]) {
            [FCFileManager removeItemAtPath:filePath];
        }
        // 转码成amr
        [EMVoiceConverter wavToAmr:self.fileDict[@"ext_file"] amrSavePath:filePath];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        [DataHelper uploadResource:data file_type:@"audio" from:nil use_type:nil success:^(id responseObject) {
            
            UpLoadResourceModel *tempModel = responseObject;
            if (tempModel.error_code == 0) {
                
                Resource *model = tempModel.data[0];
                [self createQuestion:@"audio" imageUrl:nil iamgeMd:nil videoMd:nil audioMd:model.md];
                
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:@"上传失败" duration:1.0 position:@"bottom"];
            }
            
        } fail:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:kNetWorkError duration:1.0 position:@"bottom"];
        }];
    } else {
        [self createQuestion:nil imageUrl:nil iamgeMd:nil videoMd:nil audioMd:nil];
    }
}

- (void)createQuestion:(NSString *)fileType
              imageUrl:(NSString *)imageUrl
               iamgeMd:(NSString *)imageMd
               videoMd:(NSString *)videoMd
               audioMd:(NSString *)audioMd {
    
    [CourseHelper createAnswer:_textView.text question_id:self.question_id desc_image:imageMd desc_link:imageUrl desc_video:videoMd desc_audio:audioMd success:^(id responseObject) {
        
        CreateAnswerModel *model = responseObject;
        if (model.error_code == 0) {
            
            model.data.content = _textView.text;
            NSMutableArray *array = [NSMutableArray new];
            if (imageUrl) {
                
                NSArray *tempArray = [imageUrl componentsSeparatedByString:@","];
                for (NSString *str in tempArray) {
                    if (str.length > 4) {
                        [array addObject:str];
                    }
                }
                model.data.type = 1;
            } else if (audioMd) {
                NSMutableDictionary *muDict = [NSMutableDictionary new];
                [muDict setObject:audioMd forKey:@"url"];
                [array addObject:muDict];
                model.data.type = 3;
            } else if (videoMd) {
                NSMutableDictionary *muDict = [NSMutableDictionary new];
                [muDict setObject:videoMd forKey:@"url"];
                [array addObject:muDict];
                model.data.type = 2;
            }
            model.data.arrayData = array;
            
            [self.view makeToast:@"上传成功" duration:1.0 position:@"bottom"];
            if (_block) {
                _block(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:@"上传失败" duration:1.0 position:@"bottom"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:kNetWorkError duration:1.0 position:@"bottom"];
    }];
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
