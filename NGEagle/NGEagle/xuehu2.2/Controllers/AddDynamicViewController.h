//
//  AddDynamicViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CCPublishViewController.h"

/**
 *  发布动态
 */
@interface AddDynamicViewController : CCPublishViewController
{
    
}

/**
 *  群组ID
 */
@property (nonatomic, strong) NSString *groupId;
/**
 *  群组类型 1班级 2学校 3自定义组 默认0
 */
@property (nonatomic) int groupType;

@end
