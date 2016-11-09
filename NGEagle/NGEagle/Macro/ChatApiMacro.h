//
//  ChatApiMacro.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

//########################### *******聊天相关******** ###########################

// 获取用户通讯录的统计信息
#define kApiGetContactStatistic @"/index.php?app=interface&mod=User&act=getContactStatistic"

// 获取用户信息
#define kApiGetUserInfoByUid @"/index.php?app=interface&mod=User&act=getUserInfoByUid"

// 获取好友列表
#define kApiGetFriend @"/index.php?app=interface&mod=Friend&act=getFriend"

// 获取群组成员
#define kApiGetGroupUser @"/index.php?app=interface&mod=Group&act=getGroupUser"

// 获取用户所在的群组
#define kApiGetGroup @"/index.php?app=interface&mod=Group&act=getGroup"

// 根据群组id，获取群组的基本信息
#define kApiGetGroupInfoById @"/index.php?app=interface&mod=Group&act=getGroupInfoById"

// 搜索好友
#define kApiContactSearch @"/index.php?app=interface&mod=Xuehu&act=contactSearch"

// 添加好友
#define kApiAddFriend @"/index.php?app=interface&mod=Friend&act=addFriend"

// 删除好友
#define kApiDelFriend @"/index.php?app=interface&mod=Friend&act=delFriend"

// 确认好友申请
#define kApiConfirmFriendRequest @"/index.php?app=interface&mod=Friend&act=confirmFriendRequest"

// 添加群成员
#define kApiAddGroupUser @"/index.php?app=interface&mod=Group&act=addGroupUser"

// 删除群成员
#define kApiDelGroupUser @"/index.php?app=interface&mod=Group&act=delGroupUser"

// 解散群
#define kApiDelGroup @"/index.php?app=interface&mod=Group&act=delGroup"


/************************************动态相关******************************************/
// 获取动态列表
#define kApiGetDynamicList @"/index.php?app=interface&mod=Xuehu&act=getDynamicList"

// 发布动态
#define kApiAddDynamic @"/index.php?app=interface&mod=Xuehu&act=addDynamic"

// 添加评论
#define kApiAddComment @"/index.php?app=interface&mod=Xuehu&act=addComment"

// 赞
#define kApiAddSupprotDynamic @"/index.php?app=interface&mod=Xuehu&act=support"

// 获取评论列表
#define kApiGetDynamicCommentList @"/index.php?app=interface&mod=Xuehu&act=commentList"

// 删除动态
#define kApiDeleteDynamic @"/index.php?app=interface&mod=Xuehu&act=delDynamic"






