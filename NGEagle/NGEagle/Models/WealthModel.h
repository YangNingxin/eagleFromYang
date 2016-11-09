//
//  WealthModel.h
//  NGEagle
//
//  Created by Liang on 15/8/14.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"

@protocol Wealth
@end

@interface WealthModel : ErrorModel

@property (nonatomic, strong) NSArray<Wealth> *data;

@end


@interface Wealth : JSONModel

@property (nonatomic) int type;
@property (nonatomic, strong) NSString *wealth;


@end
