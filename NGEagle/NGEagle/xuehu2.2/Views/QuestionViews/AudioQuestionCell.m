//
//  AudioQuestionCell.m
//  
//
//  Created by Liang on 16/4/16.
//
//

#import "AudioQuestionCell.h"
#import "DownLoadHelper.h"
#import "NSString+Hashing.h"
#import "FCFileManager.h"

@implementation AudioQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _audioView = [AudioView new];
    _audioView.timeLabel.hidden = YES;
    _audioView.closeButton.hidden = YES;
    [_audioView addTarget:self action:@selector(clickAudioView) forControlEvents:UIControlEventTouchUpInside];
    [_resourceView addSubview:_audioView];
    
    [_audioView.backAudio mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    [_audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_resourceView);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
}

- (void)setDynamic:(Dynamics *)dynamic {
    
    if (self.dynamic) {
        [self.dynamic removeObserver:self forKeyPath:@"status"];
    }
    
    [super setDynamic:dynamic];
    
    [self.dynamic addObserver:self forKeyPath:@"status"
                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)setQuestion:(CCQuestion *)question {
    
    if (self.question) {
        [self.question removeObserver:self forKeyPath:@"playStatus"];
    }
    
    [super setQuestion:question];
    _audioView.timeLabel.hidden = NO;
    
    MediaObject *midea = question.resource.audio[0];
    _audioView.titleLabel.text = [NSString stringWithFormat:@"%d\"", midea.time];
    
    [self.question addObserver:self forKeyPath:@"playStatus"
                       options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        [_audioView handleView:self.dynamic.status];
    } else if ([keyPath isEqualToString:@"playStatus"]) {
        [_audioView handleView:self.question.status];
    }
}

- (void)clickAudioView {
    
    if (self.dynamic) {
        [self.delegate clickAudioView:self.dynamic];
    } else if (self.question) {
        [self.delegate clickAudioView2:self.question];
    }
}

- (id)initWithChatStyle:(NSString *)reuseIdentifier {
    self = [super initWithChatStyle:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    if (self.dynamic) {
        [self.dynamic removeObserver:self forKeyPath:@"status"];
    }
    if (self.question) {
        [self.question removeObserver:self forKeyPath:@"playStatus"];
    }

    NSLog(@"%s", __func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
