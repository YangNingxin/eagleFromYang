//
//  ClassDetailViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "WebViewController.h"
#import "ClassDetailModel.h"

@interface ClassDetailViewController : WebViewController <UIAlertViewDelegate>
{
    ClassDetail *_classDetail;
}
@end
