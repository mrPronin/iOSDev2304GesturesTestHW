//
//  RITViewController.m
//  2304GesturesTestHW
//
//  Created by Aleksandr Pronin on 16.03.14.
//  Copyright (c) 2014 Aleksandr Pronin. All rights reserved.
//

#import "RITViewController.h"
#import "UIImageAnimatedGIF.h"

@interface RITViewController () <UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGFloat gifScale;
@property (assign, nonatomic) CGFloat gifRotation;

@end

@implementation RITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tap
    UITapGestureRecognizer* tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
	
    // double touch gesture
    UITapGestureRecognizer* doubleTouchGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTouch:)];
    doubleTouchGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTouchGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTouchGesture];
    
    // left swipe
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(handleRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    // zoom
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    pinchGesture.delegate = self;
    
    // rotation
    UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleRotation:)];
    [self.view addGestureRecognizer:rotationGesture];
    rotationGesture.delegate = self;
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSURL* path = [[NSBundle mainBundle] URLForResource:@"Totoro" withExtension:@"gif"];
    NSData* data = [NSData dataWithContentsOfURL:path];
    UIImage* image = [UIImage animatedImageWithAnimatedGIFData:data];
    self.gif.image = image;
    
}

#pragma mark - Gestures

- (void) handleTap:(UITapGestureRecognizer*)tapGesture {
    
    NSLog(@"Tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    //[self.gif.layer removeAllAnimations];
    
    [UIView animateWithDuration:3.f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.gif.center = [tapGesture locationInView:self.view];
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void) handleDoubleTouch:(UITapGestureRecognizer*)tapGesture {
    
    NSLog(@"Double touch: %@, animation keys: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]), self.gif.layer.animationKeys);
    
    NSArray* animationKeys = self.gif.layer.animationKeys;
    
    for (NSString* animationKey in animationKeys) {
        if ([animationKey isEqualToString:@"UIImageAnimation"]) {
            continue;
        }
        
        [self.gif.layer removeAnimationForKey:animationKey];
    }
    
}


- (void) handleLeftSwipe:(UISwipeGestureRecognizer*)swipeGesture {
    
    NSLog(@"Left swipe");
    
    CGAffineTransform currentTransform = self.gif.transform;
    
    //CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, - M_PI);
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, - 3.14f);
    //CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, - (float)M_PI);
    
    [UIView animateWithDuration:3.f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear
                     animations:^{
                         self.gif.transform = newTransform;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
}

- (void) handleRightSwipe:(UISwipeGestureRecognizer*)swipeGesture {
    
    NSLog(@"Right swipe");
    
    CGAffineTransform currentTransform = self.gif.transform;
    //CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI);
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, 3.14f);
    //CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, (float)M_PI);
    
    [UIView animateWithDuration:3.f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear
                     animations:^{
                         self.gif.transform = newTransform;
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

- (void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture {
    
    NSLog(@"Handle pinch %1.3f", pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.gifScale = 1;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.gifScale;
    
    CGAffineTransform currentTransform = self.gif.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    self.gif.transform = newTransform;
    
    self.gifScale = pinchGesture.scale;
}

- (void) handleRotation:(UIRotationGestureRecognizer*)rotationGesture {
    
    NSLog(@"Handle rotation %1.3f", rotationGesture.rotation);
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.gifRotation = 0;
    }
    
    CGFloat newRotation = rotationGesture.rotation - self.gifRotation;
    
    CGAffineTransform currentTransform = self.gif.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
    self.gif.transform = newTransform;
    
    self.gifRotation = rotationGesture.rotation;
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
