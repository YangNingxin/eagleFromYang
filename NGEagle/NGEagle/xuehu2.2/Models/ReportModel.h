//
//  ReportModel.h
//  NGEagle
//
//  Created by Liang on 16/5/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "ItemModel.h"

/**
 *  举报列表
 */
@interface ReportModel : ErrorModel

@property (nonatomic, strong) NSArray<Item> *data;

@end
