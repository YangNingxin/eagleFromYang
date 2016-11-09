//
//  AddNoteSuccess.h
//  NGEagle
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class AddNote;

@interface AddNoteSuccess : ErrorModel

@property (nonatomic, strong) AddNote *data;

@end

@interface AddNote : JSONModel

@property (nonatomic) int nid;
@property (nonatomic, strong) NSString *link_id;
@property (nonatomic, strong) NSString *content;

@end