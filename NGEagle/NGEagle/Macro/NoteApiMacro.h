//
//  NoteApiMacro.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

// 获取发布给自己的通知列表
#define kApiGetPublishToMeList @"/index.php?app=interface&mod=Announcement&act=getPublishToMeList"

// 获取通知的用户阅读状态
#define kApiGetUserReadStatus @"/index.php?app=interface&mod=Announcement&act=getUserReadStatus"

// 设置通知为已读状态
#define kApiSetReadStatus @"/index.php?app=interface&mod=Announcement&act=setReadStatus"

// 获取自己发布的通知列表
#define kApiGetMyPublishList @"/index.php?app=interface&mod=Announcement&act=getMyPublishList"

// 发布通知
#define kApiPublishNote @"/index.php?app=interface&mod=Announcement&act=publish"

// 获取通知详情
#define kApiGetNoteDetail @"/index.php?app=interface&mod=Announcement&act=getDetail"

// 获取一个通知发布的群组列表
#define kApiGetPublishedGroups @"/index.php?app=interface&mod=Announcement&act=getPublishedGroups"