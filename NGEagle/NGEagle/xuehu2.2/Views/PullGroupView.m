//
//  PullGroupView.m
//  NGEagle
//
//  Created by Liang on 16/4/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "PullGroupView.h"
#import "TypeCell.h"
#import "ChatDataHelper.h"
#import "GroupListModel.h"

@implementation PullGroupView
{
    GroupListModel *_groupList;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(247, 247, 247);
        _itemArray = @[@"好友", @"班级", @"学校", @"群组"];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[TypeCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        WS(weakSelf);
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf getGroupListFromServer];
        }];
        [_tableView.header beginRefreshing];
    }
    return self;
}

- (void)getGroupListFromServer {
    [ChatDataHelper getGroupByType:-1 success:^(id responseObject) {
        
        _groupList = responseObject;
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        
    } fail:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.toolBar setFrame:[self bounds]];
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _groupList.classes.count;
            break;
        case 2:
            return _groupList.school.count;
            break;
        case 3:
            return _groupList.defined.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.backgroundColor = RGB(247, 247, 247);
    
    UILabel *label = [UILabel new];
    label.text = _itemArray[section];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13.0];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.textColor = [UIColor lightGrayColor];
    if (_type == indexPath.row) {
        cell.iconImageView.hidden = NO;
    } else {
        cell.iconImageView.hidden = YES;
    }
    
    
    if (indexPath.section == 0) {
        cell.label.text = @"全部好友";
    } else {
        
        GroupInfo *list;
        switch (indexPath.section) {
            case 1:
                list = _groupList.classes[indexPath.row];
                break;
            case 2:
                list = _groupList.school[indexPath.row];
                break;
            case 3:
                list = _groupList.defined[indexPath.row];
                break;
            default:
                break;
        }
        cell.label.text = list.name;
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name;
    if (indexPath.section == 0) {
        _type = -1;
        name = @"好友";
    } else {
        GroupInfo *list;
        switch (indexPath.section) {
            case 1:
                list = _groupList.classes[indexPath.row];
                break;
            case 2:
                list = _groupList.school[indexPath.row];
                break;
            case 3:
                list = _groupList.defined[indexPath.row];
                break;
            default:
                break;
        }
        _type = list.gid.intValue;
        name = list.name;
    }

    [self.delegate selectType:_type name:name];
    [tableView reloadData];
}

- (void)dealloc {
    self.delegate = nil;
    NSLog(@"%s", __func__);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
