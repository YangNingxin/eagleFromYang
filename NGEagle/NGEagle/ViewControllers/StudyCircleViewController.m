//
//  StudyCircleViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "StudyCircleViewController.h"
#import "ChatListViewController.h"
#import "DynamicViewController.h"
#import "AddressViewController.h"
#import "AddFriendViewController.h"
#import "AddDynamicViewController.h"

@interface StudyCircleViewController ()
{
    //当前的控制器
    UIViewController *currViewController;
    /**
     *  状态指示器
     */
    UIImageView *stateImageView;
    NSArray *itemArray;
    // 默认是0，选择消息
    int index;
}
@end

@implementation StudyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemArray = @[@"消息", @"动态", @"通讯录"];
    
    [self initView];

    
    ChatListViewController *chatVc = [[ChatListViewController alloc]init];
    [self addChildViewController:chatVc];
    
    chatVc.view.frame = CGRectMake(0,
                                   _barImageView.bottom,
                                   SCREEN_WIDTH,
                                   self.view.height - _barImageView.height - 49);
    currViewController = chatVc;

    
    DynamicViewController *dynamicVc = [[DynamicViewController alloc] init];
    [self addChildViewController:dynamicVc];
    
    
    AddressViewController *addressVc = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    [self addChildViewController:addressVc];
    
    [self.view addSubview:chatVc.view];
    
    _leftButton.hidden = NO;
    [_leftButton setImage:[UIImage imageNamed:@"left_menu"] forState:UIControlStateNormal];

    // Do any additional setup after loading the view from its nib.
}

- (void)initView {
    
    float space = 20;
    float x = (SCREEN_WIDTH - (itemArray.count - 1) * space - itemArray.count * 60)/2;
    
    for (int i = 0; i < itemArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x + i*(space + 60), 20, 60, 44)];
        [button setTitle:itemArray[i] forState:UIControlStateNormal];
        button.tag = 100 + i;
        if (i == index) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_barImageView addSubview:button];
    }
    stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 61, 60, 3)];
    stateImageView.backgroundColor = [UIColor whiteColor];
    [_barImageView addSubview:stateImageView];
}

- (void)buttonAction:(UIButton *)button {
    
//    for (int i = 0; i < itemArray.count; i++) {
//        UIButton *tempButton = (UIButton *)[_barImageView viewWithTag:100+i];
//        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
    
    index = (int)button.tag - 100;
    UIViewController *newController = [self.childViewControllers objectAtIndex:index];
    
    if (currViewController != newController) {
        newController.view.frame = currViewController.view.frame;
        
        [self transitionFromViewController:currViewController toViewController:newController duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
            currViewController = newController;
        }];
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        stateImageView.left = button.left;
    }];
    
//    [button setTitleColor:UIColorFromRGB(0x50c0bb) forState:UIControlStateNormal];
    
    if (button.tag == 102 || button.tag == 101) {
        _rightButotn.hidden = NO;
    } else {
        _rightButotn.hidden = YES;
    }
}

- (void)configBaseUI {
    [super configBaseUI];
    _rightButotn.hidden = YES;
    [_rightButotn setImage:[UIImage imageNamed:@"add_book"] forState:UIControlStateNormal];
}

- (void)rightButtonAction {
    
    if (index == 1) { // 动态
        AddDynamicViewController *vc = [[AddDynamicViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        AddFriendViewController *addFriendVc = [[AddFriendViewController alloc] initWithNibName:@"AddFriendViewController" bundle:nil];
        addFriendVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addFriendVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
