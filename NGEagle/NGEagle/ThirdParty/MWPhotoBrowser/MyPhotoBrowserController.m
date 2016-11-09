//
//  BrowsePicturesViewController.m
//  skyeye
//
//  Created by Liang on 15/5/6.
//  Copyright (c) 2015年 Baidu inc. All rights reserved.
//

#import "MyPhotoBrowserController.h"

@implementation MyPhotoBrowserController {
     NSMutableArray *_mwPhotoArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        self.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        self.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        self.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        self.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        self.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        self.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
       
        _mwPhotoArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setIndex:(NSUInteger)index {
    _index = index;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setCurrentPhotoIndex:_index];
}

- (void)setImagesArray:(NSArray *)imagesArray {

    for (NSString *url in imagesArray) {
        [_mwPhotoArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _mwPhotoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return _mwPhotoArray[index];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
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
