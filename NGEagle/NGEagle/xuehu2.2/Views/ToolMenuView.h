//
//  ToolMenuView.h
//  NGEagle
//
//  Created by Liang on 16/4/24.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolMenuViewDelegate <NSObject>

- (void)clickMenu:(int)index;

@end
@interface ToolMenuView : UIView
{
    UIImageView *_imageView;
    UIImageView *_wordImageView;
    
}
@property (nonatomic, weak) id<ToolMenuViewDelegate>delegate;
@end
