//
//  StageAndSubjectsModel.h
//  NGEagle
//
//  Created by Liang on 16/5/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol StageAndSubjects <NSObject>
@end

@protocol SubjectModel <NSObject>
@end

/**
 *  学段和学科
 */
@interface StageAndSubjectsModel : ErrorModel

@property (nonatomic, strong) NSArray<StageAndSubjects> *data;

@end


@interface StageAndSubjects : JSONModel
@property (nonatomic) int sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<SubjectModel> *subjects;

@end

@interface SubjectModel : JSONModel

@property (nonatomic) int sid;
@property (nonatomic, strong) NSString *name;

@end