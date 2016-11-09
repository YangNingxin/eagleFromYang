//
//  CourseFilterModel.h
//  NGEagle
//
//  Created by Liang on 15/8/9.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "ItemModel.h"

@protocol CourseFilter

@end

@interface CourseFilterModel : ErrorModel

@property (nonatomic, strong) NSArray<CourseFilter> *data;

@end

@interface CourseFilter : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString<Optional> *param;
@property (nonatomic, strong) NSArray<Item> *items;

@end
