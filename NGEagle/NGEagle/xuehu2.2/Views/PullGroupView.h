//
//  PullGroupView.h
//  NGEagle
//
//  Created by Liang on 16/4/15.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullSelectGroupDelegate <NSObject>

- (void)selectType:(int)type name:(NSString *)name;

@end

@interface PullGroupView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_itemArray;
    int _type;
}
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, weak)id<PullSelectGroupDelegate>delegate;

@end
