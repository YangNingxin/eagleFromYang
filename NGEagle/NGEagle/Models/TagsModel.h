//
//  TagsModel.h
//  NGEagle
//
//  Created by Liang on 15/7/28.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "CommentListModel.h"

@interface TagsModel : ErrorModel

@property (nonatomic, strong) NSArray<Tag> *data;

@end
