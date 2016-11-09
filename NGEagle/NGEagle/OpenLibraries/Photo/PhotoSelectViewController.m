//
//  PhotoSelectViewController.m
//  Eagle
//
//  Created by 张伊辉 on 14-2-20.
//  Copyright (c) 2014年 张伊辉. All rights reserved.
//

#import "PhotoSelectViewController.h"
#import "PhotoCell.h"

@interface PhotoSelectViewController ()

@end

@implementation PhotoSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
         
        //collection
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = DefaultBackColor;
    
    assetLibrary = [[ALAssetsLibrary alloc] init];
    selectPhotoDict = [NSMutableDictionary dictionary];
    selectPhotoArray = [NSMutableArray array];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:
                                             [UIImage imageNamed:@"icon_back_custom"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(backAction)];

    
    if (!self.fileDict) {
        
        self.fileDict = [NSMutableDictionary dictionary];
        NSMutableArray *muArrImages = [NSMutableArray array];
        [self.fileDict setObject:muArrImages forKey:@"data"];

    }
   
    self.title = [self.photoDict objectForKey:@"photosName"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    float width = (SCREEN_WIDTH - 10 - 15) / 4.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:flowLayout];
    

    self.collectionView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIcollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.photoDict objectForKey:@"photosArr"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   NSString *strURL = [[self.photoDict objectForKey:@"photosArr"] objectAtIndex:indexPath.row];

    //如果没有复用的item会自动创建cell，别忘了前面我们绑定了ib哦
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:strURL];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        
        UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        cell.imageView.image=image;

    
    }failureBlock:^(NSError *error) {
        
        
        NSLog(@"error=%@",error);
        
        
    }];
    
    if ([selectPhotoDict objectForKey:strURL]) {
        
        if ([[selectPhotoDict objectForKey:strURL] isEqualToString:@"YES"]) {
            cell.statueImageView.hidden = NO;

        }else{
            cell.statueImageView.hidden = YES;

        }
        
    }else{
        
        cell.statueImageView.hidden = YES;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *strURL = [[self.photoDict objectForKey:@"photosArr"] objectAtIndex:indexPath.row];
    
    
    
  
    
    if ([selectPhotoDict objectForKey:strURL]) {
        
        if ([[selectPhotoDict objectForKey:strURL] isEqualToString:@"YES"]) {
            
            [selectPhotoDict setObject:@"NO" forKey:strURL];
            [selectPhotoArray removeObject:strURL];


        }else{
            
            if (selectPhotoArray.count + [[self.fileDict objectForKey:@"data"] count] < 9) {
                [selectPhotoDict setObject:@"YES" forKey:strURL];
                [selectPhotoArray addObject:strURL];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您最多能选择9张图片!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        
    }else{
        
        if (selectPhotoArray.count + [[self.fileDict objectForKey:@"data"] count] < 9) {
            [selectPhotoDict setObject:@"YES" forKey:strURL];
            [selectPhotoArray addObject:strURL];
            

            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您最多能选择9张图片!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    
    [self.finishBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",[selectPhotoArray count]+[[self.fileDict objectForKey:@"data"] count]] forState:UIControlStateNormal];

    
    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.finishBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",[selectPhotoArray count]+[[self.fileDict objectForKey:@"data"] count]] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishAction:(id)sender {
    
    
    __block typeof (self) blockSelf = self;
    for (int i = 0; i< selectPhotoArray.count; i++) {

        
        NSString *strURL = [selectPhotoArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:strURL];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [[blockSelf.fileDict objectForKey:@"data"] addObject:image];

            
            if (i == selectPhotoArray.count-1) {

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [blockSelf.fileDict setObject:@"0" forKey:@"type"];
                    
                    NSLog(@"获取图片完成");
                    [blockSelf dismissViewControllerAnimated:NO completion:nil];

                    [[NSNotificationCenter defaultCenter]postNotificationName:@"finishSelectImage" object:blockSelf.fileDict];
                    
                    
                });
            }
            
        }failureBlock:^(NSError *error) {
            
            NSLog(@"error=%@",error);
        }];
    }
}

@end
