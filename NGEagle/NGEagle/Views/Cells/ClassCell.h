//
//  ClassCell.h
//  NGEagle
//
//  Created by Liang on 15/7/27.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListModel.h"

@protocol ClassCellDelegate <NSObject>

- (void)bookCourse:(NSIndexPath *)indexPath;

@end

@interface ClassCell : UITableViewCell
{
    
}

@property (nonatomic, strong) ClassList *classList;
@property (nonatomic, weak) id<ClassCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSelectedLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (nonatomic, strong) NSIndexPath *indexPath;
- (IBAction)bookButtonAction:(UIButton *)sender;

@end
