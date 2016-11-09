//
//  SearchViewController.h
//  NGEagle
//
//  Created by Liang on 15/8/10.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSOperation *_searchRequest;
    NSString *_keyWords;
    int _page;
    int _pageNum;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelAction:(UIButton *)sender;

/**
 *  搜素数据
 *
 *  @param isRefresh 是否刷新
 */
- (void)searchDataFromServer:(BOOL)isRefresh;

@end
