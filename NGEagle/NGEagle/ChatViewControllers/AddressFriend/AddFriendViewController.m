//
//  AddFriendViewController.m
//  NGEagle
//
//  Created by Liang on 15/8/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AddFriendViewController.h"
#import "ContactSearchModel.h"
#import "AddressDetailViewController.h"
#import "GroupDetailViewController.h"

@interface AddFriendViewController ()
{
    /**
     *  状态指示器
     */
    UIImageView *stateImageView;
    
    NSArray *itemArray;
    // 默认是0，选择消息
    int index;
    
    NSString *keyWords;
    NSMutableArray *dataArray;
    
    NSOperation *request;
    
    BOOL isLoading;
}
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    [self initView];
    
    self.textField.placeholder = @"请输入用户ID、或用户名查找";
    // Do any additional setup after loading the view from its nib.
}

- (void)initView {
    
    itemArray = @[@"找人", @"找群", @"找班"];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i < itemArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 64, SCREEN_WIDTH/3, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:itemArray[i] forState:UIControlStateNormal];
        button.tag = 100 + i;
        if (i == index) {
            [button setTitleColor:UIColorFromRGB(0x23b1fc) forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 106, SCREEN_WIDTH/3, 2)];
    stateImageView.backgroundColor = UIColorFromRGB(0x23b1fc);
    [self.view addSubview:stateImageView];
}

- (void)searchDataFromServer {
    
    [request cancel];
    request = nil;
    
    if (!isLoading) {
        [SVProgressHUD showWithStatus:@"正在加载..."];
    }
    isLoading = YES;
    
    request = [ChatDataHelper contactSearchWithKeyWords:keyWords type:index+1 success:^(id responseObject) {
        
        ContactSearchModel *model = responseObject;
        if (model.error_code == 0) {
            
            [dataArray removeAllObjects];
            
            if (index == 0) {
                [dataArray addObjectsFromArray:model.friends];
            } else {
                [dataArray addObjectsFromArray:model.groups];
            }
            [self.tableView reloadData];
        }
        
        [SVProgressHUD dismiss];
        isLoading = NO;
        
    } fail:^(NSError *error) {
        @try {
            if (error.code != -999) { // 取消
                [SVProgressHUD dismiss];
            }
        }
        @catch (NSException *exception) {
        }
    }];
}

- (void)buttonAction:(UIButton *)button {
    
    for (int i = 0; i < itemArray.count; i++) {
        UIButton *tempButton = (UIButton *)[self.view viewWithTag:100+i];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    index = (int)button.tag - 100;
   
    [UIView animateWithDuration:0.25 animations:^{
        stateImageView.left = button.left;
    }];
    [button setTitleColor:UIColorFromRGB(0x23b1fc) forState:UIControlStateNormal];
    
    if (button.tag == 100) {
        self.textField.placeholder = @"请输入用户ID、或用户名查找";
    } else if (button.tag == 101) {
        self.textField.placeholder = @"请输入群组ID、或群组名查找";
    } else {
        self.textField.placeholder = @"请输入班级ID、或班级名查找";
    }
    
    keyWords = @"";
    self.textField.text = @"";
    [dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)configBaseUI {
    [super configBaseUI];
    _titleLabel.text = @"查找";
    [_leftButton setImage:[UIImage imageNamed:@"icon_back_custom"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40,40)];
        headImage.tag = 1;
        headImage.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:headImage];
        
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 40)];
        lblTitle.font = [UIFont systemFontOfSize:15.0];
        lblTitle.tag = 2;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lblTitle];
    }
    
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:2];
    
    UIImageView *headView = (UIImageView *)[cell.contentView viewWithTag:1];
    headView.layer.cornerRadius = 5.0;
    headView.layer.masksToBounds = YES;
    
    if (index == 0) {
        
        User *user = [dataArray objectAtIndex:indexPath.row];
        lblName.text = user.nick;
        [headView setImageWithURL:[NSURL URLWithString:user.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
        
    } else if (index == 1) {
        
        GroupInfo *group = [dataArray objectAtIndex:indexPath.row];
        lblName.text = group.name;
        [headView setImageWithURL:[NSURL URLWithString:group.logo] placeholderImage:[UIImage imageNamed:@"icon_group_chat"]];
    } else if (index == 2) {
        
        GroupInfo *group = [dataArray objectAtIndex:indexPath.row];
        lblName.text = group.name;
        [headView setImageWithURL:[NSURL URLWithString:group.logo] placeholderImage:[UIImage imageNamed:@"icon_group_chat"]];
    }
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (index == 0) {
        
        User *user = [dataArray objectAtIndex:indexPath.row];
      
        AddressDetailViewController *addressVc = [[AddressDetailViewController alloc] initWithNibName:@"AddressDetailViewController" bundle:nil];
        addressVc.user = user;
        [self.navigationController pushViewController:addressVc animated:YES];
        
    } else if (index == 1) {
        
        GroupInfo *list = dataArray[indexPath.row];
        
        GroupDetailViewController *groupVc = [[GroupDetailViewController alloc] init];
        groupVc.groupInfo = list;
        [self.navigationController pushViewController:groupVc animated:YES];
    } else {
        
        GroupInfo *list = dataArray[indexPath.row];
        
        GroupDetailViewController *groupVc = [[GroupDetailViewController alloc] init];
        groupVc.groupInfo = list;
        [self.navigationController pushViewController:groupVc animated:YES];
        
    }
}

#pragma mark
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //添加通知，当text发生改变的时候
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidChange:(NSNotification *)note {
    
    UITextField *textField = [note object];
    if (textField.text.length > 0) {
       
        keyWords = self.textField.text;
        if (keyWords.length >= 2) {
            // 取消执行方法
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchDataFromServer) object:nil];
            [self performSelector:@selector(searchDataFromServer) withObject:nil afterDelay:0.4];
        }
    }
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
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
