//
//  OrderModel.h
//  NGEagle
//
//  Created by Liang on 15/8/14.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ErrorModel.h"
#import "CourseModel.h"

@class Goods;

@protocol Order

@end

@interface OrderModel : ErrorModel

@property (nonatomic, strong) NSMutableArray<Order> *data;

@end

@interface Order : JSONModel

@property (nonatomic) int bill_id;
@property (nonatomic) int action;
@property (nonatomic, strong) NSString *format_ctime;
@property (nonatomic) int cart_id;
@property (nonatomic) int type;
@property (nonatomic) int opencourse_id;
@property (nonatomic, strong) Goods *goods;


@end


@interface Goods : JSONModel

@property (nonatomic) int cid;//: "1",
@property (nonatomic, strong) NSString *name;//: "旅行基金",
@property (nonatomic, strong) NSString *desc;// "旅行基金说明",
@property (nonatomic, strong) NSString *face;//: "http://117.121.26.76/index.php?app=interface&mod=Resource&act=image&md=227969bbca64286ea48ff6e80f23ec2a",
@property (nonatomic, strong) NSString *url;//: "http://117.121.26.76/index.php?app=webapp&mod=Opencourse&act=courseBasic&id=1",
@property (nonatomic) int credit;//: "1", //学分
@property (nonatomic, strong) NSArray<Grade> *grades;
- (NSString *)objectStudent;
@end
