//
//  VideoQuestionCell.m
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "VideoQuestionCell.h"
#import "PlayViewController.h"

@implementation VideoQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _videoView = [VideoView new];
    _videoView.closeButton.hidden = YES;
    [_resourceView addSubview:_videoView];
    
    [_videoView.backVideo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_resourceView);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200, 150));
    }];
    
    [_videoView addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setQuestion:(CCQuestion *)question {
    [super setQuestion:question];
    
    MediaObject *meida = question.resource.video[0];
    [_videoView.backVideo setImageWithURL:[NSURL URLWithString:meida.face]];
}

- (void)playVideo:(VideoView *)videoView {
    NSString *url = nil;
    
    if (self.dynamic) {
       Resource *resource = self.dynamic.resource[0];
        url = resource.url;
    }
    PlayViewController *playVc = [[PlayViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:playVc];
    playVc.url = url;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}

- (id)initWithChatStyle:(NSString *)reuseIdentifier {
    self = [super initWithChatStyle:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
