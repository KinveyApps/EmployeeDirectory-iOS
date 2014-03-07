//
//  BLAPaneController.m
//  PaneTest
//
//  Created by Ballast Lane Applications, LLC on 6/26/12.
//  Copyright (c) 2012 Electric Peel, LLC. All rights reserved.
//

#import "BLAPaneController.h"

NSTimeInterval const kSidebarTransitionDuration = 0.25;

@interface BLAPaneController () {
	UIViewController *_rootViewController;
	UIViewController *_sidebarViewController;
	
	UIView *_shadowView;
	UIView *_containerView;
	
	BOOL _sidebarVisible;
	
	UIPanGestureRecognizer *_gestureRecognizer;
	CGRect _currentRootBaseFrame;
	BOOL _rootViewIsBeingSlid;
	UITapGestureRecognizer *_tapRecognizer;
}

- (void)addShadowToView:(UIView *)view;
- (void)addSidebarToView;
- (void)removeSidebarFromView;
- (void)addShowSidebarGestureRecognizer;

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer;

- (UIImage *)defaultShadowImage;

- (void)tappedRootViewController:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation BLAPaneController

@synthesize sidebarWidthWhenVisible = _sidebarWidthWhenVisible;

- (id)initWithRootViewController:(UIViewController *)rootViewController sidebarViewController:(UIViewController *)sidebarViewController {
	self = [super init];
	if (self) {
		_rootViewController = rootViewController;
		_sidebarViewController = sidebarViewController;
		
		[self addChildViewController:_rootViewController];
		[self addChildViewController:_sidebarViewController];

		_sidebarWidthWhenVisible = 265;
	}
	
	return self;
}

#pragma mark - Accessors

- (NSArray *)viewControllers {
	if (!_rootViewController) return [NSArray array];
	
	return [NSArray arrayWithObject:_rootViewController];
}

- (BOOL)isSidebarVisible {
	return _sidebarVisible;
}

#pragma mark - Public Methods

- (UIViewController *)sidebarViewController {
	return _sidebarViewController;
}

- (UIViewController *)topViewController {
	return _rootViewController;
}

- (UIViewController *)visibleViewController {
	return _rootViewController;
}

- (void)showSidebar:(BOOL)showSidebar animated:(BOOL)animated {
	if (_sidebarVisible == showSidebar) {
		[self showSidebar:!showSidebar animated:animated];
		return;
	}
	
	_sidebarVisible = showSidebar;

	NSTimeInterval duration = 0;
	if (animated) duration = kSidebarTransitionDuration;

	UIViewAnimationOptions animationCurve;
	
	void (^animation)(void);
	void (^completion)(BOOL);
	
	if (showSidebar) {
		CGRect rootFrame = _containerView.frame;
		rootFrame.origin.x = self.sidebarWidthWhenVisible;
		
		animation = ^{
			_containerView.frame = rootFrame;
		};
		
		completion = ^(BOOL finished){
		};
		
		animationCurve = UIViewAnimationOptionCurveEaseInOut;
		
		[self addSidebarToView];
		
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRootViewController:)];
		[_rootViewController.view addGestureRecognizer:_tapRecognizer];
	}
	else {
		[_sidebarViewController willMoveToParentViewController:nil];
		
		CGRect rootFrame = _containerView.frame;
		rootFrame.origin.x = 0;
		
		animation = ^{
			_containerView.frame = rootFrame;
		};

		completion = ^(BOOL finished){
			[self removeSidebarFromView];
		};
		
		animationCurve = UIViewAnimationOptionCurveEaseInOut;
		
		[_rootViewController.view removeGestureRecognizer:_tapRecognizer];
		_tapRecognizer = nil;
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

- (void)presentNewRootViewController:(UIViewController *)viewController {
	[_rootViewController willMoveToParentViewController:nil];
	
	[self addChildViewController:viewController];
	
	CGRect frame = _rootViewController.view.frame;
	viewController.view.frame = frame;
	[self addShadowToView:viewController.view];
	
	UIViewController *oldRootViewController = _rootViewController;
	_rootViewController = viewController;
	
	[self transitionFromViewController:oldRootViewController 
					  toViewController:_rootViewController
							  duration:0
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^{
								[oldRootViewController.view removeFromSuperview];
								
								[_containerView addSubview:_rootViewController.view];
							} 
							completion:^(BOOL finished){
								[oldRootViewController removeFromParentViewController];
								[_rootViewController didMoveToParentViewController:self];
								
								if (self.sidebarVisible == YES) {
									[self showSidebar:NO animated:YES];
								}
							}
	 ];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_containerView];

	CGRect initialRootFrame = _containerView.bounds;
	
	_rootViewController.view.frame = initialRootFrame;
	[_containerView addSubview:_rootViewController.view];
	
	[self addShadowToView:_rootViewController.view];
	
	[_rootViewController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (void)addShadowToView:(UIView *)view {
	CGRect shadowFrame = self.view.bounds;
	shadowFrame.size.width = 10;
	shadowFrame.origin.x = -shadowFrame.size.width;
	
	_shadowView = [[UIImageView alloc] initWithImage:[self defaultShadowImage]];
	_shadowView.frame = shadowFrame;
	[view addSubview:_shadowView];
}

- (void)tappedRootViewController:(UIGestureRecognizer *)gestureRecognizer {
	[self showSidebar:NO animated:YES];
}

- (void)addSidebarToView {
	[self addChildViewController:_sidebarViewController];
	
	CGRect sidebarFrame;
	sidebarFrame.origin = CGPointZero;
	sidebarFrame.size.width = self.sidebarWidthWhenVisible;
	sidebarFrame.size.height = self.view.bounds.size.height;
	
	UIView *sidebarView = _sidebarViewController.view;
	sidebarView.frame = sidebarFrame;

	[self.view addSubview:sidebarView];
	[self.view sendSubviewToBack:sidebarView];

	[_sidebarViewController didMoveToParentViewController:self];
	
	_sidebarVisible = YES;
}

- (void)removeSidebarFromView {
	UIView *sidebarView = _sidebarViewController.view;

	[sidebarView removeFromSuperview];
	[_sidebarViewController removeFromParentViewController];
	
	_sidebarVisible = NO;
}

- (void)addShowSidebarGestureRecognizer {
	_gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.view addGestureRecognizer:_gestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
	if (!_rootViewIsBeingSlid) {
		_currentRootBaseFrame = _rootViewController.view.frame;
	}
	
	if (!_sidebarVisible) {
		[self addSidebarToView];
	}
	
	CGPoint translation = [gestureRecognizer translationInView:self.view];
	
	if (_currentRootBaseFrame.origin.x + translation.x > self.sidebarWidthWhenVisible) translation.x = self.sidebarWidthWhenVisible - _currentRootBaseFrame.origin.x;
	if (_currentRootBaseFrame.origin.x + translation.x < 0) translation.x = 0 - _currentRootBaseFrame.origin.x;
	
	CGRect rootViewFrame = _currentRootBaseFrame;
	rootViewFrame.origin.x += translation.x;
	
	[UIView animateWithDuration:0.01 
						  delay:0 
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						_rootViewController.view.frame = rootViewFrame;						 
					 } completion:^(BOOL finished){}];
	
	_rootViewIsBeingSlid = YES;
	NSLog(@"%f, %f %i", translation.x, translation.y, gestureRecognizer.state);
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
		CGFloat distanceToHiddenSidebar = rootViewFrame.origin.x - 0;
		CGFloat distanceToVisibleSidebar = self.sidebarWidthWhenVisible - rootViewFrame.origin.x;
		
		CGRect newRootViewFrame = _currentRootBaseFrame;
		
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
							 _rootViewController.view.frame = newRootViewFrame; 
						 } completion:^(BOOL finished){
							 _rootViewIsBeingSlid = NO;
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
    UIBarButtonItem *sidebarItem = [[UIBarButtonItem alloc] initWithImage:sideBarImage style:UIBarButtonItemStyleBordered target:self action:@selector(showSidebar:)];
	return sidebarItem;
}

@end