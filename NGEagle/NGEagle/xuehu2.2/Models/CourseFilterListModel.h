//
//  CourseFilterListModel.h
//  NGEagle
//
//  Created by Liang on 16/5/1.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol KnowledgeType <NSObject>
@end

@protocol DomainItem <NSObject>
@end

@protocol FilterItem <NSObject>
@end

@class CourseFilterList;

/**
 *  课程筛选model
 */
@interface CourseFilterListModel : ErrorModel
{
    
}
+ (CourseFilterListModel *)shareManager;

@property (nonatomic, strong) CourseFilterList *data;
@property (nonatomic, strong) CourseFilterList *resultData;

@end

@interface CourseFilterList : JSONModel

@property (nonatomic, strong) NSArray<KnowledgeType> *knowledges;
@property (nonatomic, strong) NSArray<FilterItem> *courses;
@property (nonatomic, strong) NSArray<DomainItem> *domain;

@end

@interface DomainItem : JSONModel

@property (nonatomic) int did;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *param;
@property (nonatomic) int obj_type_id;

@end

@interface KnowledgeType : JSONModel
@property (nonatomic) int kid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSArray<FilterItem> *subjects;
@property (nonatomic, strong) NSArray<FilterItem> *grades;
@end

@interface FilterItem : JSONModel
{
    BOOL _isSelect;
}
@property (nonatomic) int fid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSArray<FilterItem> *types;

- (BOOL)getSelect;
- (void)setSelect:(BOOL)isSelect;

@end
