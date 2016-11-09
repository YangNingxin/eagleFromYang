//
//  IntSubjectModel.h
//  NGEagle
//
//  Created by Liang on 15/9/3.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol IntSubject
@end

/**
 *  全部学科列表
 */
@interface IntSubjectModel : ErrorModel

@property (nonatomic, strong) NSArray<IntSubject> *data;

@end

@interface IntSubject : JSONModel

@property (nonatomic) int intId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Subject> *sub;

@end
