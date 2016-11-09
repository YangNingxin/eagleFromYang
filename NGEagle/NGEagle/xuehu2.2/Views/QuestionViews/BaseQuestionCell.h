//
//  BaseQuestionCell.h
//  NGEagle
//
//  Created by Liang on 16/4/16.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImageRightLabel.h"
#import "AppendView.h"
#import "DynamicsListModel.h"
#import "QuestionListModel.h"

@protocol BaseQuestionCellDelegate

/**
 *  按钮事件
 *
 *  @param eventType
 */
- (void)handelAction:(int)eventType dataSource:(id)object;

@end

@interface BaseQuestionCell : UITableViewCell
{
    UIView *_topView;
    // 整体内容
    UIImageView *_myContentView;
    
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    
    // 资源视图
    UIView *_resourceView;
    
    // 底部视图
    UIView *_bottomView;
    
    UILabel *_descLabel;
    LeftImageRightLabel *_supportButton;
    AppendView *_appendView;
}

/**
 *  控制按钮操作事件代理
 */
@property (nonatomic, weak) id <BaseQuestionCellDelegate> handleDelegate;

// 聊天类似的UI
- (id)initWithChatStyle:(NSString *)reuseIdentifier;
- (void)setLeft;
- (void)setRight;

// 搜搜UI
- (void)changeStyleToSearchView;
// 动态UI
- (void)changeStyleToDynamic;

// 数据源一
@property (nonatomic, strong) Dynamics *dynamic;
// 数据源二
@property (nonatomic, strong) CCQuestion *question;

/**
 *  是否是答案的UI
 */
@property (nonatomic) BOOL isAnswerUI;

/**
 *  是否是属于自己的问题
 */
@property (nonatomic) BOOL isMyQuestion;

@end
