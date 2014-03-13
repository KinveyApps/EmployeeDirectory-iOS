//
//  BLAPaneController.m
//  PaneTest
//
//  Created by Ballast Lane Applications, LLC on 6/26/12.
//  Copyright (c) 2012 Electric Peel, LLC. All rights reserved.
//

#import "BLAPaneController.h"

NSTimeInterval const kSidebarTransitionDuration = 0.25;

@interface BLAPaneController ()

@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) UIViewController *sidebarViewController;
@property (nonatomic) UIView *shadowView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) BOOL sidebarVisible;
@property (nonatomic) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGRect currentRootBaseFrame;
@property (nonatomic) BOOL rootViewIsBeingSLid;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

- (void)addShadowToView:(UIView *)view;
- (void)addSidebarToView;
- (void)removeSidebarFromView;
- (void)addShowSidebarGestureRecognizer;

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer;

- (UIImage *)defaultShadowImage;

- (void)tappedRootViewController:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation BLAPaneController

- (id)initWithRootViewController:(UIViewController *)rootViewController sidebarViewController:(UIViewController *)sidebarViewController {
	self = [super init];
	if (self) {
        rootViewController.navigationItem.leftBarButtonItem = [rootViewController sidebarItem];
        
		_rootViewController = rootViewController;
		_sidebarViewController = sidebarViewController;
		
		[self addChildViewController:_rootViewController];
		[self addChildViewController:_sidebarViewController];

		_sidebarWidthWhenVisible = 265;
        
        [self setupRootViewController:rootViewController];
	}
	
	return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (NSArray *)viewControllers {
	if (self.rootViewController == nil) return @[];
	
	return [NSArray arrayWithObject:self.rootViewController];
}

#pragma mark - Public Methods

- (UIViewController *)topViewController {
	return self.rootViewController;
}

- (UIViewController *)visibleViewController {
    return self.rootViewController;
}

- (void)showSidebar:(BOOL)showSidebar animated:(BOOL)animated {
	if (self.sidebarVisible == showSidebar) {
		[self showSidebar:!showSidebar animated:animated];
		return;
	}
	
	self.sidebarVisible = showSidebar;

	NSTimeInterval duration = 0;
	if (animated) duration = kSidebarTransitionDuration;

	UIViewAnimationOptions animationCurve;
	
	void (^animation)(void);
	void (^completion)(BOOL);
	
	if (showSidebar) {
		CGRect rootFrame = self.containerView.frame;
		rootFrame.origin.x = self.sidebarWidthWhenVisible;
		
		animation = ^{
			self.containerView.frame = rootFrame;
		};
		
		completion = ^(BOOL finished){
		};
		
		animationCurve = UIViewAnimationOptionCurveEaseInOut;
		
		[self addSidebarToView];
		
		self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRootViewController:)];
		[self.rootViewController.view addGestureRecognizer:self.tapRecognizer];
	}
	else {
		[self.sidebarViewController willMoveToParentViewController:nil];
		
		CGRect rootFrame = self.containerView.frame;
		rootFrame.origin.x = 0;
		
		animation = ^{
			self.containerView.frame = rootFrame;
		};

		completion = ^(BOOL finished){
			[self removeSidebarFromView];
		};
		
		animationCurve = UIViewAnimationOptionCurveEaseInOut;
		
		[self.rootViewController.view removeGestureRecognizer:self.tapRecognizer];
		self.tapRecognizer = nil;
	}
	
	if (animated) {
		[UIView animateWithDuration:duration
							  delay:0
							options:animationCurve
						 animations:animation
						 completion:completion];
	}
	else {
		animation();
		completion(YES);
	}
}

- (void)setupRootViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        navigationController.navigationBar.translucent = NO;
        
        UIViewController *firstViewController = [[navigationController viewControllers] firstObject];
        firstViewController.navigationItem.leftBarButtonItem = [viewController sidebarItem];
    }
}

- (void)presentNewRootViewController:(UIViewController *)viewController {
	[self.rootViewController willMoveToParentViewController:nil];
	
    [self setupRootViewController:viewController];
    
	[self addChildViewController:viewController];
	
	CGRect frame = self.rootViewController.view.frame;
	viewController.view.frame = frame;
	[self addShadowToView:viewController.view];
	
	UIViewController *oldRootViewController = self.rootViewController;
	self.rootViewController = viewController;
	
	[self transitionFromViewController:oldRootViewController 
					  toViewController:self.rootViewController
							  duration:0
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^{
								[oldRootViewController.view removeFromSuperview];
								
								[self.containerView addSubview:self.rootViewController.view];
							} 
							completion:^(BOOL finished){
								[oldRootViewController removeFromParentViewController];
								[self.rootViewController didMoveToParentViewController:self];
								
								if (self.sidebarVisible == YES) {
									[self showSidebar:NO animated:YES];
								}
							}
	 ];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.containerView];

	CGRect initialRootFrame = self.containerView.bounds;
	
	self.rootViewController.view.frame = initialRootFrame;
	[self.containerView addSubview:self.rootViewController.view];
	
	[self addShadowToView:self.rootViewController.view];
	
	[self.rootViewController didMoveToParentViewController:self];
}

#pragma mark - Private Methods

- (void)addShadowToView:(UIView *)view {
	CGRect shadowFrame = self.view.bounds;
	shadowFrame.size.width = 10;
	shadowFrame.origin.x = -shadowFrame.size.width;
	
	self.shadowView = [[UIImageView alloc] initWithImage:[self defaultShadowImage]];
	self.shadowView.frame = shadowFrame;
	[view addSubview:self.shadowView];
}

- (void)tappedRootViewController:(UIGestureRecognizer *)gestureRecognizer {
	[self showSidebar:NO animated:YES];
}

- (void)addSidebarToView {
	[self addChildViewController:self.sidebarViewController];
	
	CGRect sidebarFrame;
	sidebarFrame.origin = CGPointZero;
	sidebarFrame.size.width = self.sidebarWidthWhenVisible;
	sidebarFrame.size.height = self.view.bounds.size.height;
	
	UIView *sidebarView = self.sidebarViewController.view;
	sidebarView.frame = sidebarFrame;

	[self.view addSubview:sidebarView];
	[self.view sendSubviewToBack:sidebarView];

	[self.sidebarViewController didMoveToParentViewController:self];
	
	self.sidebarVisible = YES;
}

- (void)removeSidebarFromView {
	UIView *sidebarView = self.sidebarViewController.view;

	[sidebarView removeFromSuperview];
	[self.sidebarViewController removeFromParentViewController];
	
	self.sidebarVisible = NO;
}

- (void)addShowSidebarGestureRecognizer {
	self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.view addGestureRecognizer:self.gestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
	if (!self.rootViewIsBeingSLid) {
		self.currentRootBaseFrame = self.rootViewController.view.frame;
	}
	
	if (!self.sidebarVisible) {
		[self addSidebarToView];
	}
	
	CGPoint translation = [gestureRecognizer translationInView:self.view];
	
	if (self.currentRootBaseFrame.origin.x + translation.x > self.sidebarWidthWhenVisible) translation.x = self.sidebarWidthWhenVisible - self.currentRootBaseFrame.origin.x;
	if (self.currentRootBaseFrame.origin.x + translation.x < 0) translation.x = 0 - self.currentRootBaseFrame.origin.x;
	
	CGRect rootViewFrame = self.currentRootBaseFrame;
	rootViewFrame.origin.x += translation.x;
	
	[UIView animateWithDuration:0.01 
						  delay:0 
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						self.rootViewController.view.frame = rootViewFrame;
					 } completion:^(BOOL finished){}];
	
	self.rootViewIsBeingSLid = YES;
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
		CGFloat distanceToHiddenSidebar = rootViewFrame.origin.x - 0;
		CGFloat distanceToVisibleSidebar = self.sidebarWidthWhenVisible - rootViewFrame.origin.x;
		
		CGRect newRootViewFrame = self.currentRootBaseFrame;
		
		if (distanceToHiddenSidebar < distanceToVisibleSidebar) {
			newRootViewFrame.origin.x = 0;
		}
		else {
			newRootViewFrame.origin.x = self.sidebarWidthWhenVisible;
		}
		
		[UIView animateWithDuration:0.15
							  delay:0 
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 self.rootViewController.view.frame = newRootViewFrame;
						 } completion:^(BOOL finished){
							 self.rootViewIsBeingSLid = NO;
							 if (newRootViewFrame.origin.x == 0) {
								 [self removeSidebarFromView];
							 }
						 }];
	}
}

- (UIImage *)defaultShadowImage {
	CGSize size = CGSizeMake(10, 10);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat locations[] = { 0.0, 1.0 };
	CGFloat components[] = { 0, 0, 0, 0, 0, 0, 0, 0.5 };
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, sizeof(locations)/sizeof(CGFloat));
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(10, 0), 0);
	
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	return image;
}

@end

@implementation UIViewController (BLAPaneController)

- (BLAPaneController *)paneController {
	UIViewController *parentViewController = self.parentViewController;
	if ([parentViewController isKindOfClass:[UINavigationController class]]) {
		parentViewController = parentViewController.parentViewController;
	}
	
	if ([parentViewController isKindOfClass:[BLAPaneController class]]) {
		return (BLAPaneController *)parentViewController;
	}
	else {
		return nil;
	}
}

- (void)showSidebar:(id)sender {
    [self.paneController showSidebar:YES animated:YES];
}

- (UIBarButtonItem *)sidebarItem {
    UIImage *sideBarImage = [UIImage imageNamed:@"SidebarButton"];
    UIBarButtonItem *sidebarItem = [[UIBarButtonItem alloc] initWithImage:sideBarImage style:UIBarButtonItemStylePlain target:self action:@selector(showSidebar:)];
	return sidebarItem;
}

@end
