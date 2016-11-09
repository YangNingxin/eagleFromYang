//
//  AddCommentViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AddCommentViewController.h"
#import "BdTextView.h"
#import "DYRateView.h"
#import "StringSizeUtil.h"

@interface AddCommentViewController () <DYRateViewDelegate>
{
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
    
    BdTextView *textView;
    DYRateView *rateView;
    UILabel *scoreLabel;
    
    int score;
}
@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self getTags];
    // Do any additional setup after loading the view from its nib.
}

- (void)getTags {
    
    [DataHelper getAppraiseTagsWithType:1 success:^(id responseObject) {
        self.tagsModel = responseObject;
        [self addTages];
    } fail:^(NSError *error) {
        
    }];
}

- (void)initUI {
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self initTopView];
    [self initMiddleView];
    [self initBottomView];
}

- (void)initTopView {
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    [self.scrollView addSubview:topView];
    
    textView = [[BdTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    [textView setPlaceholder:@"请输入课程评价内容："];
    [textView setPlaceholderOriginX:2 originY:8];
    textView.font = [UIFont systemFontOfSize:15.0];
    [textView setPlaceholderFont:[UIFont systemFontOfSize:15.0]];
    [topView addSubview:textView];
}

- (void)initMiddleView {
    
    middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 45)];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:middleView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 14, 4, 17)];
    lineImageView.backgroundColor = RGB(99, 192, 186);
    [middleView addSubview:lineImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 35)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = @"课程评分：";
    [middleView addSubview:label];
    
    rateView = [[DYRateView alloc] initWithFrame:CGRectMake(120, 15, 120, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 4;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = YES;
    rateView.right = SCREEN_WIDTH - 60;
    rateView.delegate = self;
    [middleView addSubview:rateView];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 100, 35)];
    scoreLabel.font = [UIFont systemFontOfSize:15.0];
    scoreLabel.text = @"0分";
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.right = SCREEN_WIDTH - 10;
    scoreLabel.textColor = [UIColor orangeColor];
    [middleView addSubview:scoreLabel];
}

- (void)initBottomView {
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 115 + 30)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bottomView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 14, 4, 17)];
    lineImageView.backgroundColor = RGB(99, 192, 186);
    [bottomView addSubview:lineImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 35)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = @"课程印象：";
    [bottomView addSubview:label];
}

- (void)addTages {
    
    for (int i = 0; i < self.tagsModel.data.count; i++) {
        Tag *tag = self.tagsModel.data[i];
        

        float width = (SCREEN_WIDTH - 30) / 2.0;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = 100 + i;
        button.frame = CGRectMake(i%2 * (width + 10) + 5,
                                  i/2 * 30 + 45,
                                  width, 22);
        
        [button setTitle:tag.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [bottomView addSubview:button];
        
        float realWidth = [StringSizeUtil getContentSizeWidth:tag.name font:[UIFont systemFontOfSize:15.0] height:16];
        button.width = realWidth + 10;
    }
}

- (void)buttonAction:(UIButton *)button {
    
    if (!button.isSelected) {
        
        if (self.number < 2) {
            
            button.layer.borderColor = RGB(99, 192, 186).CGColor;
            [button setTitleColor:RGB(99, 192, 186) forState:UIControlStateNormal];
            
            [button setSelected:YES];
            
            self.number++;
        }
        
    } else {
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setSelected:NO];
        
        self.number--;
    }
    
}

- (void)configBaseUI {
    
    [super configBaseUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleLabel.text = @"课程评论";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
    [_rightButotn setTitle:@"完成" forState:UIControlStateNormal];
}


- (NSString *)getTagString {
    
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < _tagsModel.data.count; i++) {
        Tag *tag = _tagsModel.data[i];
        UIButton *button = (UIButton *)[bottomView viewWithTag:100 + i];
        if (button.isSelected) {
            [string appendFormat:@"%d,", tag.tid];
        }
    }
    NSLog(@"tags is %@", string);
    return string;
}

- (void)rightButtonAction {
    
    if (textView.text.length == 0) {
        [self.view makeToast:@"评论内容不能为空" duration:1.0 position:@"center"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    
    [DataHelper addAppraiseWithType:1 type_id:self.cid tag:[self getTagString] star:score content:textView.text success:^(id responseObject) {
        ErrorModel *model = responseObject;
        if (model && model.error_code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showSuccessWithStatus:model.error_msg];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"评论失败"];
    }];
}


- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    scoreLabel.text = [NSString stringWithFormat:@"%@分", rate];
    score = [rate intValue];
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
