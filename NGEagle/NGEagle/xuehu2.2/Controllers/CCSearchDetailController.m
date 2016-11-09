//
//  CCSearchDetailController.m
//  NGEagle
//
//  Created by Liang on 16/4/19.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCSearchDetailController.h"
#import "LeftLabelRightImage.h"
#import "SearchCourseCell.h"
#import "AudioQuestionCell.h"
#import "ImageQuestionCell.h"
#import "VideoQuestionCell.h"
#import "MyPhotoBrowserController.h"

@interface CCSearchDetailController () <UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate, ImageQuestionCellDelegate>
{
    UIView *_searchView;
    LeftLabelRightImage *_leftView;
    UITextField *_textField;
    UIImageView *_statusImageView;
    UIView *topView;
    
    UIImageView *_popView;
    UITableView *_tableView;
    
    AudioQuestionCell *_audioCell;
    ImageQuestionCell *_imageCell;
    VideoQuestionCell *_videoCell;
    NSArray *_imageArray;
}
@end

@implementation CCSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArray = @[@"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg",
                    @"http://pic.962.net/up/2016-4/201641584151329320.jpg"];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    // 注册cell
    [_tableView registerClass:[AudioQuestionCell class] forCellReuseIdentifier:@"AudioQuestionCell"];
    [_tableView registerClass:[ImageQuestionCell class] forCellReuseIdentifier:@"ImageQuestionCell"];
    [_tableView registerClass:[VideoQuestionCell class] forCellReuseIdentifier:@"VideoQuestionCell"];
    [_tableView registerClass:[SearchCourseCell class] forCellReuseIdentifier:@"SearchCourseCell"];

    _audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell"];
    _imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell"];
    _videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell"];
}

- (void)initUI {
    _searchView = [UIView new];
    _searchView.layer.cornerRadius = 3.0;
    _searchView.layer.masksToBounds = YES;
    _searchView.backgroundColor = [UIColor whiteColor];
    [_barImageView addSubview:_searchView];
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(27);
        make.height.mas_offset(30);
        make.right.mas_offset(-50);
    }];
    
    _leftView = [LeftLabelRightImage new];
    _leftView.backgroundColor = [UIColor clearColor];
    _leftView.label.font = [UIFont systemFontOfSize:14.0];
    _leftView.label.textColor = UIColorFromRGB(0x333333);
    [_searchView addSubview:_leftView];
    
    [_leftView initWithData:@"校内搜" image:[UIImage imageNamed:@"black_down"]];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.centerY.mas_offset(0);
    }];
    
    UITapGestureRecognizer *tapLeftView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapLeftAction)];
    [_leftView addGestureRecognizer:tapLeftView];
    
    UIView *vLineView = [UIView new];
    vLineView.backgroundColor = RGB(204, 204, 204);
    [_searchView addSubview:vLineView];
    
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftView.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(0.5, 16));
        make.centerY.equalTo(_searchView);
    }];
    
    UIView *tempView = [UIView new];
    tempView.backgroundColor = [UIColor clearColor];
    [_searchView addSubview:tempView];
    
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vLineView.mas_right).offset(5);
        make.right.mas_offset(-5);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_searchView);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _textField = [UITextField new];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UIColorFromRGB(0x333333);
        _textField.placeholder = @"输入关键字搜索";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        _textField.font = [UIFont systemFontOfSize:15.0];
        [tempView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    });
    
    topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(64);
        make.height.mas_offset(36);
    }];
    
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton new];
        button.tag = 20 + i;
        [button addTarget:self action:@selector(selectSubType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [topView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(i * 50 + 10);
            make.top.mas_offset(0);
            make.height.equalTo(topView);
        }];
        
        switch (i) {
            case 0:
                [button setTitle:@"课程" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"专辑" forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:@"问答" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    _statusImageView = [UIImageView new];
    _statusImageView.backgroundColor = kThemeColor;
    [topView addSubview:_statusImageView];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(topView.mas_bottom).offset(10);
    }];
    
    if (self.subType != -1) {
        // 默认显示状态
        UIButton *button = [topView viewWithTag:20 + self.subType];
        [self updateStatusImageView:button];
    }
    
    if (self.type == 0) {
        _leftView.label.text = @"校内搜";
    } else {
        _leftView.label.text = @"云课堂搜";
    }
}
- (void)configBaseUI {
    [super configBaseUI];
    _leftButton.hidden = YES;
    [_rightButotn setTitle:@"取消" forState:UIControlStateNormal];
    _titleLabel.hidden = YES;
}

- (void)tapLeftAction {
    
    if (!_popView) {
        _popView = [UIImageView new];
        _popView.userInteractionEnabled  = YES;
        _popView.image = [UIImage imageNamed:@"back_pop"];
        [self.view addSubview:_popView];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.top.mas_offset(52);
        }];
        
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton new];
            button.tag = 10 + i;
            [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [_popView addSubview:button];
            
            switch (i) {
                case 0:
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_offset(8);
                        make.centerX.mas_equalTo(0);
                    }];
                    [button setTitle:@"校内搜" forState:UIControlStateNormal];
                    break;
                case 1:
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_offset(-5);
                        make.centerX.mas_equalTo(0);
                    }];
                    [button setTitle:@"云课堂搜" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        
    } else
    {
        [_popView setHidden:!_popView.isHidden];
    }
}

- (void)selectType:(UIButton *)button {
    if (button.tag == 10) {
        self.type = 0;
        _leftView.label.text = @"校内搜";
    } else {
        self.type = 1;
        _leftView.label.text = @"云课堂搜";
    }
    _popView.hidden = YES;
}

- (void)selectSubType:(UIButton *)button {
    [self updateStatusImageView:button];
}

- (void)updateStatusImageView:(UIButton *)button {
    [_statusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(button);
        make.centerX.equalTo(button);
        make.height.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)rightButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        _imageCell.imageArray = _imageArray;
        [_imageCell changeStyleToSearchView];
        CGSize size = [_imageCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    } else if (indexPath.row == 1) {
        [_audioCell changeStyleToSearchView];
        CGSize size = [_audioCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return 1 + size.height;
    }
    [_videoCell changeStyleToSearchView];
    CGSize size = [_videoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1 + size.height;
    
    // 课程的东西
    return 108;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
        ImageQuestionCell  *imageCell = [_tableView dequeueReusableCellWithIdentifier:@"ImageQuestionCell" forIndexPath:indexPath];
        [imageCell changeStyleToSearchView];
        imageCell.delegate = self;
        imageCell.imageArray = _imageArray;
        return imageCell;
    } else if (indexPath.row == 1) {
        AudioQuestionCell *audioCell = [_tableView dequeueReusableCellWithIdentifier:@"AudioQuestionCell" forIndexPath:indexPath];
        [audioCell changeStyleToSearchView];
        return audioCell;
    } else {
        VideoQuestionCell *videoCell = [_tableView dequeueReusableCellWithIdentifier:@"VideoQuestionCell" forIndexPath:indexPath];
        [videoCell changeStyleToSearchView];
        return videoCell;
    }
    SearchCourseCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SearchCourseCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
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
