//
//  QuestionListModel.m
//  NGEagle
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "QuestionListModel.h"

@implementation QuestionListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation CCQuestion

/*
- (int)resourceType {
    
    if (self.resource) {
        if (self.resource.image && self.resource.image.count > 0) {
            return 1;
        } else if (self.resource.video && self.resource.video.count > 0) {
            return 2;
        } else if (self.resource.audio && self.resource.audio.count > 0) {
            return 3;
        }
    }
    return 1;
} 
*/

- (int)resourceType {
    
    if (_resourceType == 0) {
        return 1;
    }
    return _resourceType;
}
//- (void)setResourceType:(int)resourceType {
//    if (resourceType == 0) {
//        _resourceType = 1;
//    } else {
//        _resourceType = resourceType;
//    }
//}

- (NSMutableArray *)imageArray {
    
    if (_imageArray) {
        return _imageArray;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    if (self.resource.image && self.resource.image.count > 0) {
        [tempArray addObjectsFromArray:self.resource.image];
    }
    
    return tempArray;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"id": @"qid",
                                 @"resource_type" : @"resourceType"
                                 }];
}
@end


@implementation QuestionResource
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MediaObject
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation QuestionDetailModel
@end





