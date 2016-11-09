//
//  AdvisoryCellDelegate.h
//  rehab
//
//  Created by Liang on 15/8/26.
//  Copyright (c) 2015年 renxin. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol ImageGroupCellDelegate <NSObject>

/**
 *  点击图片
 */
@required
- (void)clickAdvisoryCellImage:(NSIndexPath *)indexPath imagesArray:(NSArray *)imagesArray;

@end
