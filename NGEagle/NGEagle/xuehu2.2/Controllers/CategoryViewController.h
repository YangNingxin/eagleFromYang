//
//  CategoryViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "SifterCourseView.h"

@interface CategoryViewController : BaseViewController<SifterCourseViewDelegate>
{
    SifterCourseView *_sifterCourseView;
    UIView *_topView;
}
@property (nonatomic) int type;
@end
