//
//  AudioQuestionCell.h
//  
//
//  Created by Liang on 16/4/16.
//
//

#import "BaseQuestionCell.h"
#import "AudioView.h"

@protocol AudioQuestionCellDelegate <NSObject>

@optional
- (void)clickAudioView:(Dynamics *)dynamic;
- (void)clickAudioView2:(CCQuestion *)question;

@end

@interface AudioQuestionCell : BaseQuestionCell
{
    AudioView *_audioView;
}
@property (nonatomic, weak) id<AudioQuestionCellDelegate>delegate;

@end
