//
//  ShareView.h
//  NGEagle
//
//  Created by Liang on 16/4/10.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BasePopView.h"
typedef void(^ItemClick)(int index);

@interface ShareView : BasePopView

- (void)setClickEventBlock:(ItemClick)block;

@end
