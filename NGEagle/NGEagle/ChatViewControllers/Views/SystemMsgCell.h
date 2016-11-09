//
//  SystemMsgCell.h
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface SystemMsgCell : UITableViewCell<UIActionSheetDelegate> {
    int msg_type;
    int msg_subType;
}
@property (nonatomic, strong) MessageModel *messageModel;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;


@end
