/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  PopView.m
//  PhotoPop
//
//  Created by Bill Dudney on 2/7/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "PopView.h"

static CGFloat kLayerWidth = 105.0f;
static CGFloat kLayerHeight = 78.75f;
static CGFloat kGroupDuration = 5.0f;
static CGFloat kFadeDuration = 1.0f;

@interface PopView(Color)
- (CGColorRef)black;
@end

@implementation PopView

- (CGFloat)randomNumberLessThan:(CGFloat)top {
  return ((CGFloat)random() / (CGFloat)RAND_MAX) * top;
}

- (CGImageRef)imageNamed:(NSString *)name ofType:(NSString *)type {
  CGImageRef image = NULL;
  NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                   ofType:type];
  NSURL *imageURL = [NSURL fileURLWithPath:path];
  CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
  if(NULL != src) {
    image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
    CFRelease(src);
  }
  return image;
}

- (CALayer *)createLayerForImageNamed:(NSString *)name 
                               ofType:(NSString *)type {
  CALayer *layer = [CALayer layer];
  layer.contents = (id)[self imageNamed:name ofType:type];
  layer.bounds = 
  CGRectMake(0.0f, 0.0f, kLayerWidth, kLayerHeight);
  layer.position = CGPointMake(NSMaxX([self bounds]) - kLayerWidth / 2.0f,
                               NSMidY([self bounds]));
  layer.name = name;
  layer.delegate = self;
  layer.opacity = 0.0f;
  return layer;
}

- (CAKeyframeAnimation *)rotation {
  CAKeyframeAnimation *rot = 
  [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
  CGFloat angle = 30.0f * (M_PI/180.0f);
  rot.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], 
                [NSNumber numberWithFloat:angle], 
                [NSNumber numberWithFloat:-angle], 
                [NSNumber numberWithFloat:0.0f], nil];
  rot.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
                  [NSNumber numberWithFloat:0.25f],
                  [NSNumber numberWithFloat:0.75f],
                  [NSNumber numberWithFloat:1.0f], nil];
  rot.timeOffset = [self randomNumberLessThan:2.0f]; 
  return rot;
}

- (CABasicAnimation *)xLocation {
  CABasicAnimation *xLoc = [CABasicAnimation animationWithKeyPath:@"position.x"];
  CGFloat halfWidth = kLayerWidth / 2.0f;
  xLoc.fromValue = [NSNumber numberWithFloat:NSMaxX([self bounds]) - halfWidth];
  xLoc.toValue = [NSNumber numberWithFloat:NSMinX([self bounds]) - halfWidth];
  return xLoc;
}

- (CABasicAnimation *)fadeIn {
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:0.0f];
  fade.toValue = [NSNumber numberWithFloat:1.0f];
  fade.speed = kGroupDuration; 
  fade.fillMode = kCAFillModeForwards; 
  return fade;
}

- (CABasicAnimation *)fadeOut {
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:1.0f];
  fade.toValue = [NSNumber numberWithFloat:0.0f];
  fade.duration = kFadeDuration;
  fade.beginTime = kGroupDuration - kFadeDuration; 
  return fade;
}

- (CAAnimationGroup *)group { 
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.duration = kGroupDuration;
  group.animations = [NSArray arrayWithObjects:[self rotation], 
                      [self xLocation], [self fadeIn], 
                      [self fadeOut], nil];
  return group;
}

- (IBAction)move:(id)sender {
  [beach1Layer addAnimation:[self group] forKey:@"fly"];
  [beach2Layer addAnimation:[self group] forKey:@"fly"];
  [beach3Layer addAnimation:[self group] forKey:@"fly"];
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  self.layer.backgroundColor = [self black];
  [self setWantsLayer:YES];
  
  beach1Layer = [self createLayerForImageNamed:@"beach1" ofType:@"jpg"];
  CGFloat y = NSMinY([self bounds]) + kLayerHeight / 2.0f;
  [beach1Layer setValue:[NSNumber numberWithFloat:y] forKeyPath:@"position.y"];
  [self.layer addSublayer:beach1Layer];
  
  beach2Layer = [self createLayerForImageNamed:@"beach2" ofType:@"jpg"];
  [self.layer addSublayer:beach2Layer];
  
  beach3Layer = [self createLayerForImageNamed:@"beach3" ofType:@"jpg"];
  y = NSMaxY([self bounds]) - kLayerHeight / 2.0f;
  [beach3Layer setValue:[NSNumber numberWithFloat:y] forKeyPath:@"position.y"];
  [self.layer addSublayer:beach3Layer];
}

@end

@implementation PopView (Color)

- (CGColorSpaceRef)genericRGBSpace {
  static CGColorSpaceRef space = NULL;
  if(NULL == space) {
    space = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
  }
  return space;
}

- (CGColorRef)black {
  static CGColorRef black = NULL;
  if(black == NULL) {
    CGFloat values[4] = {0.0, 0.0, 0.0, 1.0};
    black = CGColorCreate([self genericRGBSpace], values);
  }
  return black;
}

@end
