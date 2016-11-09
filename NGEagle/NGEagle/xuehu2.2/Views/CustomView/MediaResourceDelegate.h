
//
//  MediaResourceDelegate.h
//  NGEagle
//
//  Created by Liang on 16/4/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

@protocol MediaResourceDelegate <NSObject>

/**
 *  删除资源
 */
- (void)deleteMediaResource:(int)type;

@end
