//
//  AddCommentSuccess.h
//  NGEagle
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class AddComment;

/**
 *  添加评论成功
 */
@interface AddCommentSuccess : ErrorModel

@property (nonatomic, strong) AddComment *data;

@end

@interface AddComment : JSONModel

@property (nonatomic) int cid;
@property (nonatomic, strong) User *user;

@end