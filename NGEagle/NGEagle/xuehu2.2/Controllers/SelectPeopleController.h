//
//  SelectPeopleController.h
//  NGEagle
//
//  Created by Liang on 16/4/14.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FinishSelectPeople)(NSString *result, int number);

@interface SelectPeopleController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *_tableView;
}
- (void)setFinishSelectPeopleBlock:(FinishSelectPeople)block;
@end
