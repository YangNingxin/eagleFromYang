//
//  SelectViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FinishSelectBlock)(id itemSelect);

@interface SelectViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    FinishSelectBlock _block;
}
@property (nonatomic) int index;

/**
 *  选项
 */
@property (nonatomic, strong) NSMutableArray *itemArray;


@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)setFinishSelectBlock:(FinishSelectBlock)block;

@end
