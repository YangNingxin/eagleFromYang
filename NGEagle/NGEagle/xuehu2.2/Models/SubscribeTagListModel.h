//
//  SubscribeTagListModel.h
//  NGEagle
//
//  Created by Liang on 16/5/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "CCCourseListModel.h"
@protocol SubscribeTag<NSObject>
@end

/**
 *  订阅的知识点课程model
 */
@interface SubscribeTagListModel : ErrorModel
@property (nonatomic, strong) NSArray<SubscribeTag> *data;
@end

@interface SubscribeTag : JSONModel

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<CCCourse> *courses;

@end
