//
//  CourseViewController.h
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "BaseViewController.h"
#import "SifterCourseView.h"
#import "CourseModel.h"

@interface CourseViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SifterCourseViewDelegate> {
    
    NSOperation *_newRequest;
    int _newPage;
    int _pageNum;
    NSOperation *_hotRequest;
    int _hotPage;
    
    CourseModel *_newModel;
    CourseModel *_hotModel;
    NSDictionary *_params;

}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *cNewButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

- (IBAction)hotClickAction:(UIButton *)sender;
- (IBAction)newClickAction:(UIButton *)sender;
- (IBAction)selectClickAction:(UIButton *)sender;

@end
