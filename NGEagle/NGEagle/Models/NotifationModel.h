//
//  NotifationModel.h
//  NGEagle
//
//  Created by Liang on 15/9/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"


@protocol Notefation <NSObject>

@end

@interface NotifationModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Notefation> *data;

@end


@interface Notefation : JSONModel

@property (nonatomic) int nid;
@property (nonatomic) int user_id;
@property (nonatomic) int type;
@property (nonatomic) int target_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) int ctime;

@property (nonatomic, strong) NSString *face;

/**
 *  0--未读，1--已读，2--已发回执，4--用户已删除
 */
@property (nonatomic) int read_status;

@property (nonatomic, strong) User *user;

@end
