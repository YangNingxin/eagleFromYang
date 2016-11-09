//
//  WTAZoomNavigationController.m
//  WTAZoomNavigationController
//
//  Created by Andrew Carter on 11/13/13.
//  Copyright (c) 2013 Andrew Carter. All rights reserved.
//

#import "WTAZoomNavigationController.h"
#define UIHeight [[UIScreen mainScreen] bounds].size.height
#define UIWidth [[UIScreen mainScreen] bounds].size.width
#import <objc/runtime.h>

const char *WTAZoomNavigationControllerKey = "WTAZoomNavigationControllerKey";
static const CGFloat WTAContentContainerViewOriginX = 130.0f;//150.0f; BY Jessic
static const CGFloat WTAContentContainerViewAngle = (M_PI/130*40);// BY Jessic

static inline void wta_UIViewSetFrameOriginX(UIView *view, CGFloat originX) {
    [view setFrame:CGRectMake(originX, CGRectGetMinY([view frame]), CGRectGetWidth([view frame]), CGRectGetHeight([view frame]))];
}

@implementation UIViewController (WTAZoomNavigationController)

- (void)clickDrawerButton:(id)sender
{
    [[self wta_zoomNavigationController] revealLeftViewController:YES];
    
}

- (WTAZoomNavigationController *)wta_zoomNavigationController
{
    WTAZoomNavigationController *panNavigationController = objc_getAssociatedObject(self, &WTAZoomNavigationControllerKey);
    if (!panNavigationController)
    {
        panNavigationController = [[self parentViewController] wta_zoomNavigationController];
    }
    
    return panNavigationController;
}

- (void)setWta_zoomNavigationController:(WTAZoomNavigationController *)wta_zoomNavigationController
{
    objc_setAssociatedObject(self, &WTAZoomNavigationControllerKey, wta_zoomNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface WTAZoomNavigationView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *leftContainerView;
@property (nonatomic, strong) UIButton *contentContainerButton;

@end

@implementation WTAZoomNavigationView

#pragma mark - UIView Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setScrollView:[[UIScrollView alloc] initWithFrame:[self bounds]]];
        [[self scrollView] setScrollsToTop:NO];
        [[self scrollView] setBounces:NO];
        [[self scrollView] setScrollEnabled:NO];//Test By Jessica
        [[self scrollView] setShowsHorizontalScrollIndicator:NO];
        [[self scrollView] setShowsVerticalScrollIndicator:NO];
        [[self scrollView] setBackgroundColor:[UIColor clearColor]];
        [[self scrollView] setContentSize:CGSizeMake(CGRectGetWidth(frame) + WTAContentContainerViewOriginX, CGRectGetHeight(frame))];
        
        [self setLeftContainerView:[[UIView alloc] initWithFrame:[self bounds]]];
        [[self scrollView] addSubview:[self leftContainerView]];
        
        [self setContentContainerView:[[UIView alloc] initWithFrame:[self bounds]]];
        wta_UIViewSetFrameOriginX([self contentContainerView], WTAContentContainerViewOriginX);
        [[self contentContainerView] setBackgroundColor:[UIColor clearColor]];
        [[self scrollView] addSubview:[self contentContainerView]];
        
        [self setContentContainerButton:[UIButton buttonWithType:UIButtonTypeCustom]];
        [[self contentContainerButton] setFrame:[[self contentContainerView] bounds]];
        [[self contentContainerView] addSubview:[self contentContainerButton]];
        
        [[self scrollView] setContentOffset:CGPointMake(WTAContentContainerViewOriginX, 0.0f) animated:NO];
        
        [self addSubview:[self scrollView]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [[self backgroundView] setFrame:[self bounds]];
    [[self contentContainerView] bringSubviewToFront:[self contentContainerButton]];
}

#pragma mark - Accessors

- (void)setBackgroundView:(UIView *)backgroundView
{
    [[self backgroundView] removeFromSuperview];
    _backgroundView = backgroundView;
    [self insertSubview:[self backgroundView] atIndex:0];
}

@end

@interface WTAZoomNavigationController () <UIScrollViewDelegate>

@property (nonatomic, strong) WTAZoomNavigationView *zoomNavigationView;

@end

@implementation WTAZoomNavigationController

#pragma mark - UIViewController Overrides
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)loadView
{
    WTAZoomNavigationView *view;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        view = [[WTAZoomNavigationView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];

    }else{
        view = [[WTAZoomNavigationView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight-20)];
    }
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self setZoomNavigationView:view];
    [self setView:[self zoomNavigationView]];
}

- (void)viewDidLoad
{
    [[[self zoomNavigationView] scrollView] setDelegate:self];
    [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:NO];
    [[[self zoomNavigationView] contentContainerButton] addTarget:self action:@selector(contentContainerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Accessors

- (void)setBackgroundView:(UIView *)backgroundView
{
    [[self zoomNavigationView] setBackgroundView:backgroundView];
}

- (UIView *)backgroundView
{
    return [[self zoomNavigationView] backgroundView];
}

- (UIScrollView *)scrollView
{
    return [[self zoomNavigationView] scrollView];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (![self isViewLoaded])
    {
        [self view];
    }
    UIViewController *currentContentViewController = [self contentViewController];
    _contentViewController = contentViewController;
    
    UIView *contentContainerView = [[self zoomNavigationView] contentContainerView];
    CGAffineTransform currentTransform = [contentContainerView transform];
    CATransform3D currentTransform3D = [contentContainerView.layer transform];//3D BY Jessic
    
    [contentContainerView setTransform:CGAffineTransformIdentity];
    [contentContainerView.layer setTransform:CATransform3DIdentity];//3D BY Jessic
    
    [self replaceController:currentContentViewController
              newController:[self contentViewController]
                  container:[[self zoomNavigationView] contentContainerView]];
    
    [contentContainerView setTransform:currentTransform];
    [contentContainerView.layer setTransform:currentTransform3D];//3D BY Jessic
    [[self zoomNavigationView] setNeedsLayout];
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (![self isViewLoaded])
    {
        [self view];
    }
    UIViewController *currentLeftViewController = [self leftViewController];
    _leftViewController = leftViewController;
    [self replaceController:currentLeftViewController
              newController:[self leftViewController]
                  container:[[self zoomNavigationView] leftContainerView]];
}

#pragma mark - Instance Methods

- (void)contentContainerButtonPressed:(id)sender
{
    [self hideLeftViewController:YES];
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController container:(UIView *)container
{
    if (newController)
    {
        [self addChildViewController:newController];
        [[newController view] setFrame:[container bounds]];
        [newController setWta_zoomNavigationController:self];
        
        if (oldController)
        {
            [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:0 animations:nil completion:^(BOOL finished) {
                
                [newController didMoveToParentViewController:self];
                
                [oldController willMoveToParentViewController:nil];
                [oldController removeFromParentViewController];
                [oldController setWta_zoomNavigationController:nil];
                
            }];
        }
        else
        {
            [container addSubview:[newController view]];
            [newController didMoveToParentViewController:self];
        }
    }
    else
    {
        [[oldController view] removeFromSuperview];
        [oldController willMoveToParentViewController:nil];
        [oldController removeFromParentViewController];
        [oldController setWta_zoomNavigationController:nil];
    }
}

- (void)updateContentContainerButton
{
    CGPoint contentOffset = [[[self zoomNavigationView] scrollView] contentOffset];
    CGFloat contentOffsetX = contentOffset.x;
    if (contentOffsetX < WTAContentContainerViewOriginX)
    {
        [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:YES];
    }
    else
    {
        [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:NO];
    }
}

- (void)hideLeftViewController:(BOOL)animated
{
    [self hideLeftViewController:animated completion:nil];
}

- (void)revealLeftViewController:(BOOL)animated
{
    [self revealLeftViewController:animated completion:nil];
}

- (void)hideLeftViewController:(BOOL)animated completion:(void (^)())completion
{
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:20.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [[self scrollView] setContentOffset:CGPointMake(WTAContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:NO];
            if (completion)
            {
                completion();
            }
            
        }];
    
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [[self scrollView] setContentOffset:CGPointMake(WTAContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:NO];
            if (completion)
            {
                completion();
            }

        }];
    
    
    }
    
    
}

- (void)revealLeftViewController:(BOOL)animated completion:(void (^)())completion
{
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:20.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [[self scrollView] setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            
            [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:YES];
            if (completion)
            {
                completion();
            }
            
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [[self scrollView] setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            [[[self zoomNavigationView] contentContainerButton] setUserInteractionEnabled:YES];
            if (completion)
            {
                completion();
            }

        }];

    
    }
    
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = [scrollView contentOffset];
    CGFloat contentOffsetX = contentOffset.x;
    static BOOL leftContentViewControllerVisible = NO;
    
//    CGFloat contentContainerScale = powf((contentOffsetX + WTAContentContainerViewOriginX) / (WTAContentContainerViewOriginX * 2.0f), .5f);
//    if (isnan(contentContainerScale))
//    {
//        contentContainerScale = 0.0f;
//    }
    
    CGFloat contentContainerScale = [self contentContainerScaleWithOffsetX:contentOffsetX];
    
//    NSLog(@"-----------------contentContainerScale:%f", contentContainerScale);
    
    CGFloat contentContainerAngleReal = (1-(contentOffsetX + WTAContentContainerViewOriginX) / (WTAContentContainerViewOriginX*2))*WTAContentContainerViewAngle;//3D BY Jessic
    
    CGFloat contentContainerAngle = contentContainerScale==1?0:contentContainerAngleReal;//3D BY Jessic
    
    
//    NSLog(@"-------------contentContainerScale:%f", contentContainerScale);
//    NSLog(@"-------------contentContainerAngle:%f", contentContainerAngle);
    CATransform3D contentTransform3D = CATransform3DMakeScale(contentContainerScale, contentContainerScale, contentContainerScale);//3D BY Jessic
    contentTransform3D.m34 = 0.0015;//3D BY Jessic
    contentTransform3D = CATransform3DRotate(contentTransform3D, contentContainerAngle, 0, 1, 0);//(M_PI/180*20)//3D BY Jessic

    
//    CGAffineTransform contentContainerViewTransform = CGAffineTransformMakeScale(contentContainerScale, contentContainerScale);
    CGAffineTransform leftContainerViewTransform = CGAffineTransformMakeTranslation(contentOffsetX / 1.5f, 0.0f);
    
//    [[[self zoomNavigationView] contentContainerView] setTransform:contentContainerViewTransform];
    [[self zoomNavigationView] contentContainerView].layer.transform = contentTransform3D;//3D BY Jessic
    [self setShadowWithView:self.zoomNavigationView.contentContainerView isShadow:contentContainerScale==1?NO:YES];//阴影 BY Jessic
    
    
    
    [[[self zoomNavigationView] leftContainerView] setTransform:leftContainerViewTransform];
    [[[self zoomNavigationView] leftContainerView] setAlpha:1 - contentOffsetX / WTAContentContainerViewOriginX];
    
    if (contentOffsetX >= WTAContentContainerViewOriginX)
    {
        [scrollView setContentOffset:CGPointMake(WTAContentContainerViewOriginX, 0.0f) animated:NO];
        if (leftContentViewControllerVisible)
        {
            [[self leftViewController] beginAppearanceTransition:NO animated:YES];
            [scrollView setContentOffset:CGPointMake(WTAContentContainerViewOriginX, 0.0f) animated:NO];
            [[self leftViewController] endAppearanceTransition];
            leftContentViewControllerVisible = NO;
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    else if (contentOffsetX < WTAContentContainerViewOriginX && !leftContentViewControllerVisible)
    {
        [[self leftViewController] beginAppearanceTransition:YES animated:YES];
        leftContentViewControllerVisible = YES;
        [[self leftViewController] endAppearanceTransition];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
            [self setNeedsStatusBarAppearanceUpdate];
    }
    
//    BOOL isShadow = contentContainerScale==0?YES:NO;
//    [self setShadowWithView:[[self zoomNavigationView] contentContainerView] isShadow:isShadow];//阴影 BY Jessic
}

//BY Jessic
- (CGFloat)contentContainerScaleWithOffsetX:(CGFloat)offsetX
{
    CGFloat contentContainerScale = powf((offsetX + WTAContentContainerViewOriginX) / (WTAContentContainerViewOriginX * 2.0f), .5f);
    if (isnan(contentContainerScale))
    {
        contentContainerScale = 0.0f;
    }
    
    return contentContainerScale;

}

//BY Jessic
- (void)setShadowWithView:(UIView *)aView isShadow:(BOOL)isShadow
{
    if (isShadow) {
        aView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
        aView.layer.shadowOpacity = 0.3f;
        aView.layer.shadowOffset = CGSizeMake(-6.0, 3.0);
        aView.layer.shadowRadius = 3;
    }else{
        aView.layer.shadowColor = [UIColor clearColor].CGColor;
        aView.layer.shadowOpacity = 0;
        aView.layer.shadowOffset = CGSizeZero;
        aView.layer.shadowRadius = 0;
        
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContentContainerButton];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self updateContentContainerButton];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGSize contentSize = [scrollView contentSize];
    CGFloat targetContentOffsetX = targetContentOffset->x;
    if (targetContentOffsetX <= (contentSize.width / 2.0f) - WTAContentContainerViewOriginX)
    {
        targetContentOffset->x = 0.0f;
    }
    else
    {
        targetContentOffset->x = WTAContentContainerViewOriginX;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    UIViewController *viewController;
    if ([[self scrollView] contentOffset].x < WTAContentContainerViewOriginX)
    {
        viewController = [self leftViewController];
    }
    else
    {
        viewController = [self contentViewController];
    }
    return viewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    UIViewController *viewController;
    if ([[self scrollView] contentOffset].x < WTAContentContainerViewOriginX)
    {
        viewController = [self leftViewController];
    }
    else
    {
        viewController = [self contentViewController];
    }
    return viewController;
}

@end
