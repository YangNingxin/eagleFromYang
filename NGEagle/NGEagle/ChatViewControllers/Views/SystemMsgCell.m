//
//  SystemMsgCell.m
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SystemMsgCell.h"
#import "UserDao.h"
#import "UserInfoModel.h"

@implementation SystemMsgCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Initialization code
    self.dataDict = [NSMutableDictionary dictionary];
    self.headImageView.layer.cornerRadius = 25.0;
    self.headImageView.layer.masksToBounds = YES;
    
    self.lineImageView.backgroundColor = RGB(220, 220, 220);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setMessageModel:(MessageModel *)messageModel {
    _messageModel  = messageModel;
    
    [self.dataDict setValuesForKeysWithDictionary:[CCJsonKit getObjectFromJsonString:_messageModel.content]];
    
    self.contentLabel.text = self.dataDict[@"msg_content"];
    
    msg_type = [self.dataDict[@"msg_type"] intValue];
    msg_subType = [self.dataDict[@"msg_subtype"] intValue];
    
    self.accessoryType = UITableViewCellStyleDefault;

    
    // 好友型消息
    if (msg_type == 1) {
        
        if (!self.dataDict[@"logo"]) {
            [self setUserInfoByUid:self.dataDict[@"send_uid"]];
        } else {
            
            [self.headImageView setImageWithURL:[NSURL URLWithString:self.dataDict[@"logo"]]];
            self.nameLabel.text = self.dataDict[@"nick"];
        }
        
        // 为好友请求是可以点击的，其他情况默认不点击
        if (msg_subType == 0) {
            self.accessoryType = UITableViewCellStyleValue1;
        }

    } else {
        
        self.headImageView.image = [UIImage imageNamed:@"system_icon"];
        self.nameLabel.text = @"系统消息";
        
    }
    
    
}


/**
 *  设置用户
 *
 *  @param conversation
 *  @param cell
 */
- (void)setUserInfoByUid:(NSString *)uid {
    
    [[DBManager shareManager] openDataBase];
    [UserDao createUser];
    
    // 去数据库中取数据
    User *user = [UserDao selectUserByUid:uid];
    if (user.uid.length > 0) {
        
        [self.headImageView setImageWithURL:[NSURL URLWithString:user.logo]];
        self.nameLabel.text = user.nick;
        
        [self.dataDict setObject:user.nick forKey:@"nick"];
        [self.dataDict setObject:user.logo forKey:@"logo"];
        
    } else {
        
        [ChatDataHelper getUserInfoByUid:uid success:^(id responseObject) {
            
            UserInfoModel *infoModel = responseObject;
            if (infoModel.error_code == 0) {
                if (infoModel.user.uid) {
                    
                    [UserDao insertUser:infoModel.user];
                    
                    [self.headImageView setImageWithURL:[NSURL URLWithString:infoModel.user.logo]];
                    self.nameLabel.text = infoModel.user.nick;
                    
                    [self.dataDict setObject:infoModel.user.nick forKey:@"nick"];
                    [self.dataDict setObject:infoModel.user.logo forKey:@"logo"];
                }
            }
            
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapAction {

    // 好友型消息
    if (msg_type == 1) {
        
        // 为好友请求是可以点击的，其他情况默认不点击
        if (msg_subType == 0) {

            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意",@"拒绝", nil];
            [sheet showInView:self ];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 2) {
        return;
    }
    
    int action = (int)buttonIndex + 1;
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];

    [ChatDataHelper confirmFriendRequest:self.dataDict[@"send_uid"] status:action success:^(id responseObject) {
        
        ErrorModel *model = responseObject;
        if (model.error_code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:model.error_msg];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
}

@end



/*
 
 
 消息结构
 {
 ‘send_type’:1	//发送者类型；0个人，1学校，2班级，3自定义组，4临时会话，20开放班级
 ‘send_uid’:1	//发送者id
	‘recv_type’:0	//接受者类型；同发送者
	‘recv_uid’:1	//接受者id
	‘msg_type’:0	//消息类型
	‘msg_subtype’:0	//消息子类型
	‘msg_content’:””	//消息正文
	“msg_resource”:””	//消息附加内容
	“msg_time”:0	//消息发送时间
 }
 
 消息结构说明
 1、	send_type，send_id确定唯一发送者账户；recv_type，recv_id确定唯一接受者账户
 2、	msg_type及msg_subtype确定消息类型
 3、	msg_content为消息实体
 4、	msg_resource为消息附带属性 json 根据msg_type msg_subtype来定。当msg_type=0且msg_subtype=2的时候，该字段包含一个type和url，同其他资源字段设置。
 
 msg_type及msg_subtype具体定义
 1、	msg_type=0为正常消息msg_subtype=0普通消息，1系统消息，2为资源消息（文件）
 2、	msg_type=1为好友型消息msg_subtype=0为请求，1为通过，2为拒绝，3为删除
 3、	msg_type=2为群组型消息 msg_subtype=0为请求，1为通过，2为拒绝，3为删除
 4、	msg_type=3为动态消息 msg_subtype=0为评论，1为回复，2为动态中@，3为评论中@
 5、   msg_type=4为课程消息 msg_subtype=0为作业催交（resource包括task_id，及作业id）
 6、   msg_type=5为开放课程消息  msg_subtype=0为确定开课，1为取消开课，2为课程结束（resource包括opencourse_id, openclass_id）
 
 */





