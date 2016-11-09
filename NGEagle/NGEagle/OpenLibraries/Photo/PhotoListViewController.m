//
//  PhotoListViewController.m
//  Eagle
//
//  Created by 张伊辉 on 14-2-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoSelectViewController.h"
@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)cancelAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    muArrPhotoes = [NSMutableArray array];
    
    assetLibrary = [[ALAssetsLibrary alloc] init];

    
    __block typeof (self) blockSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location !=  NSNotFound) {
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法访问相册.请在\"设置->隐私->照片设置为打开状态\"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url'
                    
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                             //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    
                    NSMutableDictionary *muDict = [muArrPhotoes lastObject];
                    NSMutableArray *tempMuarr=[muDict objectForKey:@"photosArr"];
                    [tempMuarr addObject:urlstr];
                    
                    
                }
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2 = @"相机胶卷";
                }
                NSString *groupName=g2;//组的name
                NSLog(@"groupName is %@",groupName);
                
                NSString *strCount=[[arr objectAtIndex:2] substringFromIndex:14];
                
                NSMutableDictionary *muDict=[[NSMutableDictionary alloc]init];
                [muDict setObject:groupName forKey:@"photosName"];
                [muDict setObject:strCount forKey:@"photosNumber"];
                
                NSMutableArray *muArr=[[NSMutableArray alloc]init];
                [muDict setObject:muArr forKey:@"photosArr"];
                
                [muArrPhotoes addObject:muDict];
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [blockSelf.tableView reloadData];
                    NSLog(@"muarr is %@",muArrPhotoes);
                });
               
 
            }
            
        };
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
        });

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [muArrPhotoes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55, 50)];
        imageView.tag = 1;
        [cell addSubview:imageView];
        
        
        UILabel *lblNum = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 200, 30)];
        lblNum.tag = 2;
        lblNum.backgroundColor = [UIColor clearColor];
        lblNum.font = [UIFont systemFontOfSize:15.0];
        lblNum.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:lblNum];
    }
    NSDictionary *dict = [muArrPhotoes objectAtIndex:indexPath.row];
    NSMutableArray *tempMuarr2 = [dict objectForKey:@"photosArr"];
    
    if ([tempMuarr2 count] != 0) {
        
        NSString *urlStr2 = [tempMuarr2 lastObject];


        NSURL *url = [NSURL URLWithString:urlStr2];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            ((UIImageView *)[cell viewWithTag:1]).image=image;
            NSLog(@"sdfsaf");
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }];
    }

    ((UILabel *)[cell viewWithTag:2]).text = [NSString stringWithFormat:@"%@  (%@)",[dict objectForKey:@"photosName"],[dict objectForKey:@"photosNumber"]];

    if ([[dict objectForKey:@"photosArr"] count]>0) {
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *muDict = [muArrPhotoes objectAtIndex:indexPath.row];

    if ([[muDict objectForKey:@"photosArr"] count] > 0) {
        
        PhotoSelectViewController *detailViewController = [[PhotoSelectViewController alloc] initWithNibName:@"PhotoSelectViewController" bundle:nil];
        detailViewController.fileDict = self.fileDict;
        detailViewController.photoDict = muDict;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
}
 


@end
