//
//  MineViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"


@interface MineViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>{
    UIImageView *headBackImgView;
    UITableView *myTable;
    UIImageView *headImgView;
    UILabel *nameLab;
    UILabel *schoolLab;
    
    /**
     *  1：老师  2：学生
     */
    int userType;
}

@end
