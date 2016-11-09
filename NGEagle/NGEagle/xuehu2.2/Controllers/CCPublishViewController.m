//
//  CCPublishViewController.m
//  NGEagle
//
//  Created by Liang on 16/4/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCPublishViewController.h"
#import "IQKeyboardManager.h"
#import "PhotoListViewController.h"
#import "UIImageUtil.h"
#import "BrowsePicturesViewController.h"
#import "ImageModel.h"
#import "AudioView.h"
#import "VideoView.h"
#import "InputAudioView.h"
#import "SelectPeopleController.h"
#import "PlayViewController.h"
#import "ChatDataHelper.h"

// 横排4个
#define kNumber 4
#define kInputViewHeight 240

@interface CCPublishViewController () <InputAudioViewDelegate, MediaResourceDelegate>
{
    float _keyboardHeight;
    InputAudioView *_inputView;
}
@end

@implementation CCPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_rightButotn setTitle:@"提交" forState:UIControlStateNormal];
    _rightButotn.hidden = NO;
    
    [self initUI];
    
    if (!self.fileDict) {
        // 初始化数据
        self.fileDict = [NSMutableDictionary new];
        NSMutableArray *imageArray = [NSMutableArray array];
        [self.fileDict setObject:imageArray forKey:@"data"];
        [self.fileDict setObject:@"-1" forKey:@"type"];
    } else {
        [self addImages];
    }
    
    // 添加键盘弹起事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishSelectImage:)
                                                 name:@"finishSelectImage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteResourceAction:)
                                                 name:@"deleteResourceAction"
                                               object:nil];
    // Do any additional setup after loading the view.
}


- (void)keyboardWillShow:(NSNotification *)note {
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = rect.size.height ;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-_keyboardHeight);
        }];
        [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(kInputViewHeight);
        }];
        [_toolBarView.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNote {
    
    _keyboardHeight = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-_keyboardHeight);
        }];
        [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(kInputViewHeight);
        }];
        [_toolBarView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _itemView1.numberLabel.text = [NSString stringWithFormat:@"%d人", _idNumber];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)initUI {
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    
    _containerView = [UIView new];
    [_scrollView addSubview:_containerView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [_containerView addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    
    _textView = [EMTextView new];
    [_topView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(120);
    }];
    
    _topResView = [UIView new];
    _topResView.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_topResView];
    
    [_topResView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textView);
        make.top.equalTo(_textView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
//    float space = 10;
//    float width = (SCREEN_WIDTH - (kNumber - 1) * space - 20) / kNumber;
//    
//    for (int i = 0; i < 9; i++) {
//        UIImageView *tempView = [UIImageView new];
//        tempView.contentMode = UIViewContentModeScaleAspectFill;
//        tempView.clipsToBounds = YES;
//        tempView.image = [UIImage imageNamed:@"default_head"];
//        [_topResView addSubview:tempView];
//        
//        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(i % kNumber * (width + space));
//            make.top.mas_equalTo(i / kNumber * (width + space));
//            make.size.mas_equalTo(CGSizeMake(width, width));
//        }];
//        
//        if (i == 8) {
//            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(0);
//            }];
//        }
//    }
    
    _itemView1 = [ItemView new];
    [_itemView1 addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_itemView1];
    
    [_itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.height.mas_offset(44);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_itemView1.mas_bottom);
    }];
    [self initToolBar];
    [self initInputAudioView];
}

- (void)selectItem:(ItemView *)itemView {
    SelectPeopleController *selectVc = [[SelectPeopleController alloc] init];
    [selectVc setFinishSelectPeopleBlock:^(NSString *result, int number) {
        _ids = result;
        _idNumber = number;
    }];
    [self.navigationController pushViewController:selectVc animated:YES];
}

- (void)rightButtonAction {
    
}

- (void)initToolBar {
    
    _toolBarView = [UIView new];
    _toolBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolBarView];
    
    [_toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    float width = 36;
    int number = 4;
    float space = (SCREEN_WIDTH - 30 - number * width) / (number - 1);
    for (int i = 0; i < number; i++) {
        UIButton *button = [UIButton new];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:button];
        
        switch (i) {
            case 0:
                [button setImage:[UIImage imageNamed:@"btn_photo"] forState:UIControlStateNormal];
                break;
            case 1:
                [button setImage:[UIImage imageNamed:@"btn_take_photo"] forState:UIControlStateNormal];
                break;
            case 2:
                [button setImage:[UIImage imageNamed:@"btn_audio"] forState:UIControlStateNormal];
                break;
            case 3:
                [button setImage:[UIImage imageNamed:@"btn_video"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolBarView);
            make.left.mas_equalTo(15 + i * (width + space));
        }];
    }
}

- (void)initInputAudioView {
    _inputView = [InputAudioView new];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kInputViewHeight);
        make.bottom.mas_equalTo(kInputViewHeight);
    }];
}

- (void)handleToolBarButton {
    
    int type = [self.fileDict[@"type"] intValue];
    if (type == 1 || type == 2) {
        ((UIButton *)[_toolBarView viewWithTag:10]).enabled  = NO;
        ((UIButton *)[_toolBarView viewWithTag:11]).enabled = NO;
        ((UIButton *)[_toolBarView viewWithTag:12]).enabled = NO;
        ((UIButton *)[_toolBarView viewWithTag:13]).enabled = NO;
    } else if (type == 0) {
        
        ((UIButton *)[_toolBarView viewWithTag:12]).enabled = NO;
        ((UIButton *)[_toolBarView viewWithTag:13]).enabled = NO;
        
        NSArray *images = self.fileDict[@"data"];
        if (images.count == 9) {
            ((UIButton *)[_toolBarView viewWithTag:10]).enabled = NO;
            ((UIButton *)[_toolBarView viewWithTag:11]).enabled = NO;
            
        } else {
            ((UIButton *)[_toolBarView viewWithTag:10]).enabled = YES;
            ((UIButton *)[_toolBarView viewWithTag:11]).enabled = YES;
        }
    } else {
        ((UIButton *)[_toolBarView viewWithTag:10]).enabled = YES;
        ((UIButton *)[_toolBarView viewWithTag:11]).enabled = YES;
        ((UIButton *)[_toolBarView viewWithTag:12]).enabled = YES;
        ((UIButton *)[_toolBarView viewWithTag:13]).enabled = YES;
    }
}

- (void)buttonClick:(UIButton *)btn {
    [_textView resignFirstResponder];
    if (btn.tag != 12) {
        [self closeInputview];
    }
    if (btn.tag == 10) {

        [[UINavigationBar appearance] setBarTintColor:kThemeColor];
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        PhotoListViewController *photoListVc =
        [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
        photoListVc.fileDict = self.fileDict;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoListVc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else if (btn.tag == 11 || btn.tag == 13) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            if (btn.tag == 11) {
                // 拍照
                imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            } else {
                // 拍视频
                [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeMedium];
                imagePicker.videoMaximumDuration = 60;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
            }
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
    } else if (btn.tag == 12) {
        // 语音
        [UIView animateWithDuration:0.25 animations:^{
            [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [_toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-kInputViewHeight);
            }];
            [_inputView.superview layoutIfNeeded];
        }];
    }
}

#pragma mark
#pragma mark photoes
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

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
        [self.fileDict setObject:videoURL forKey:@"ext_file"];
        
        [self addVideo];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishSelectImage:(NSNotification *)note {
    self.fileDict = note.object;
    [self addImages];
}

- (void)deleteResourceAction:(NSNotification *)note {
    int index = [[note object] intValue];
    
    NSMutableArray *imagesArray = self.fileDict[@"data"];
    [imagesArray removeObjectAtIndex:index];
    if (imagesArray.count == 0) {
        [self.fileDict setObject:@"-1" forKey:@"type"];
    }
    [self addImages];
}

/**
 *  添加图片
 */
- (void)addImages {
    
    @autoreleasepool {
        for (UIView *v in _topResView.subviews) {
            if (v.tag >= 100) {
                [v removeFromSuperview];
            }
        }
    }

    NSArray *array = self.fileDict[@"data"];

    float space = 10;
    float width = (SCREEN_WIDTH - (kNumber - 1) * space - 20) / kNumber;
    
    for (int i = 0; i < array.count; i++) {
        UIImageView *tempView = [UIImageView new];
        tempView.contentMode = UIViewContentModeScaleAspectFill;
        tempView.clipsToBounds = YES;
        tempView.tag = 100 + i;
        tempView.image = array[i];
        tempView.userInteractionEnabled = YES;
        [_topResView addSubview:tempView];
        
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i % kNumber * (width + space));
            make.top.mas_equalTo(i / kNumber * (width + space));
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
        
        if (i == array.count - 1) {
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
        [tempView addGestureRecognizer:tap];
    }
    [self handleToolBarButton];
}

/**
 *  添加视频
 */
- (void)addVideo {
    VideoView *_videoView = [VideoView new];
    _videoView.delegate = self;
    [_videoView addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_topResView addSubview:_videoView];
    
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200, 150));
        make.bottom.mas_equalTo(0);
    }];
    [self handleToolBarButton];
}

- (void)playVideo {
    
    NSURL *url = self.fileDict[@"ext_file"];
    
    PlayViewController *playVc = [[PlayViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:playVc];
    playVc.fileURL = url;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}

/**
 *  添加语音
 */
- (void)addAudio {
    AudioView *_audioView = [AudioView new];
    _audioView.delegate = self;
    [_topResView addSubview:_audioView];
    
    [_audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.bottom.mas_equalTo(0);
    }];
    [self handleToolBarButton];
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
    browseVc.index = (int)tap.view.tag - 100;
    [self.navigationController pushViewController:browseVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MediaResourceDelegate
/**
 *  删除资源
 */
- (void)deleteMediaResource:(int)type {
    [self.fileDict removeObjectForKey:@"ext_file"];
    [self.fileDict setObject:@"-1" forKey:@"type"];
    if (type == 1) {
        
    } else {
        
    }
    [self handleToolBarButton];
}

#pragma mark InputAudioViewDelegate
- (void)finishRecord:(NSString *)filePath audioSecond:(int)audioSecond {
    
    [self.fileDict setObject:@"2" forKey:@"type"];
    [self.fileDict setObject:filePath forKey:@"ext_file"];
    
    [self addAudio];
    [self closeInputview];
}

- (void)closeInputview {
    
    [UIView animateWithDuration:0.25 animations:^{
        [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(kInputViewHeight);
        }];
        [_toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [_inputView.superview layoutIfNeeded];
    }];
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

@implementation ItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftLabel = [LeftImageRightLabel new];
        self.leftLabel.label.textColor = [UIColor lightGrayColor];
        [self addSubview:self.leftLabel];
        [self.leftLabel initWithData:@"请选择人" image:[UIImage imageNamed:@"add_button"]];
        
        WS(weakSelf);
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(weakSelf);
        }];
        
        self.nextView = [UIImageView new];
        self.nextView.backgroundColor = [UIColor clearColor];
        self.nextView.image = [UIImage imageNamed:@"gray_next"];
        [self addSubview:self.nextView];
        
        [self.nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(weakSelf);
        }];
        
        self.numberLabel = [UILabel new];
        self.numberLabel.text = @"5人";
        self.numberLabel.textColor = [UIColor lightGrayColor];
        self.numberLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.nextView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf);
        }];
    }
    return self;
}

@end
