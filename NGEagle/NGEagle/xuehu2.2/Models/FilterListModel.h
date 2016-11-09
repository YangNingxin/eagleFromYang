//
//  FilterListModel.h
//  NGEagle
//
//  Created by Liang on 16/5/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@class FilterList;
@protocol Filter <NSObject>

@end

/**
 *  针对课程的筛选，主要是学科和年级
 */
@interface FilterListModel : ErrorModel

@property (nonatomic, strong) FilterList *data;

@end

@interface FilterList : JSONModel

@property (nonatomic, strong) NSArray<Filter> *grades;
@property (nonatomic, strong) NSArray<Filter> *subjects;

@end

@interface Filter : JSONModel

@property (nonatomic) int fid; //1",
@property (nonatomic, strong) NSString *name; //小学一年级",
@property (nonatomic) int stage_id; //1",
@property (nonatomic) int national_standard_id; //11",
@property (nonatomic) int ctime; //0",
@property (nonatomic) BOOL status; //0",
@property (nonatomic) int weike_count; //2"
@property (nonatomic) int parent_id; //0",
@property (nonatomic, strong) NSString *alias; //",
@property (nonatomic, strong) NSString *tag; //",
@property (nonatomic) int flag; //0",

@end


