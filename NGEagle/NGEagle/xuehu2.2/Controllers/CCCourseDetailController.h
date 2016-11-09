//
//  CCCourseDetailController.h
//  NGEagle
//
//  Created by Liang on 16/4/7.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "WebViewController.h"
#import "CCBaseWebController.h"
#import "CCCourseListModel.h"

@interface CCCourseDetailController : CCBaseWebController
{
    
}

@property (nonatomic, strong) CCCourse *course;

/**
 *  课程id
 */
@property (nonatomic) int courseId;
/**
 *  502代表课程集，其他是微课
 */
@property (nonatomic) int obj_type_id;

@end
