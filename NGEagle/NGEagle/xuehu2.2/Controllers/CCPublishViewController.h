//
//  CCPublishViewController.h
//  NGEagle
//
//  Created by Liang on 16/4/11.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftImageRightLabel.h"
#import "EMTextView.h"
@class ItemView;

@interface CCPublishViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIScrollView *_scrollView;
    UIView *_containerView;
    
    // top视图
    UIView *_topView;
    
    // 输入文本
    EMTextView *_textView;
    // 资源视图
    UIView *_topResView;
    
    // 选项视图
    ItemView *_itemView1;
    
    UIView *_toolBarView;
    NSString *_ids;
    int _idNumber;
}
@property (nonatomic, strong) NSMutableDictionary *fileDict;

- (void)selectItem:(ItemView *)itemView;

@end

@interface ItemView : UIButton

@property (nonatomic, strong) LeftImageRightLabel *leftLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *nextView;

@end

