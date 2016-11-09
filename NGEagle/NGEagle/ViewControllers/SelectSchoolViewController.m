//
//  SelectSchoolViewController.m
//  NGEagle
//
//  Created by Liang on 15/7/18.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "SelectSchoolViewController.h"
#import "TMCache.h"

@interface SelectSchoolViewController ()

@end

@implementation SelectSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _keyWords = @"";
    _titleLabel.text = @"选择学校";
    
    [_textField setPlaceholder:@"请输入学校名称"];
    [_textField setValue:UIColorFromRGB(0xb6b6b7) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont systemFontOfSize:12.0]
              forKeyPath:@"_placeholderLabel.font"];
    self.topView.backgroundColor = RGB(215, 215, 215);
    
    [self getHotDataFromServer];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view from its nib.
}

- (void)getHotDataFromServer {
    _hotRequest = [DataHelper getHotLoginNode:^(id responseObject) {
        _hotSchoolModel = responseObject;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)searchSchoolDataFromServer {
    [_schoolRequest cancel];
    _schoolRequest = nil;
    NSLog(@"keywords = %@", _keyWords);
    _schoolRequest = [DataHelper getAllLoginNodeWithKeyWord:_keyWords success:^(id responseObject) {
        _schoolModel = nil;
        _schoolModel = responseObject;
        [self.tableView reloadData ];
    } fail:^(NSError *error) {
        
    }];
}

- (BOOL)isSearch {
    return _keyWords.length > 0;
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearch]) {
        return _schoolModel.data.count;
    }
    return _hotSchoolModel.data.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc] init];
        if ([self isSearch]) {
            label.text = @"    学校列表";

        } else {
            label.text = @"    热门学校";
        }
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor lightGrayColor];
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indefier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 100;
        [cell addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        label.tag = 101;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15.0];
        [cell addSubview:label];
    }
    UIImageView *imageView = [cell viewWithTag:100];
    UILabel *label = [cell viewWithTag:101];
    
    SchoolInfo *info = nil;
    if ([self isSearch]) {
        info = _schoolModel.data[indexPath.row];
    } else {
        info = _hotSchoolModel.data[indexPath.row];
    }
    [imageView setImageWithURL:[NSURL URLWithString:info.logo] placeholderImage:[UIImage imageNamed:@"default_head"]];
    label.text = info.name;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolInfo *info = nil;
    if ([self isSearch]) {
        info = _schoolModel.data[indexPath.row];
    } else {
        info = _hotSchoolModel.data[indexPath.row];
    }
    [Account shareManager].schoolInfo = info;
    
    [[TMCache sharedCache] setObject:info forKey:@"node"];
    [self leftButtonAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _keyWords = textField.text;
    if (textField.text.length >= 2) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchSchoolDataFromServer) object:nil];
        [self performSelector:@selector(searchSchoolDataFromServer) withObject:nil afterDelay:0.4];
    }
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
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
