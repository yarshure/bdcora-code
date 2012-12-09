/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  ActionView.m
//  AnimationAndActions
//
//  Created by Bill Dudney on 2/12/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "ActionView.h"
#import <QuartzCore/QuartzCore.h>

@interface ActionView(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)red;
@end

@implementation ActionView

- (void)setUpAnimations:(CALayer *)layer {
  CABasicAnimation *animation = [CABasicAnimation animation];
  animation.duration = 0.5f;
  layer.actions = [NSDictionary dictionaryWithObject:animation 
                                              forKey:@"opacity"];
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  self.layer.backgroundColor = [self black];
  [self setWantsLayer:YES];
  CALayer *layer = [CALayer layer];
  //layer.delegate = self;
  [self setUpAnimations:layer];
  layer.backgroundColor = [self white];
  layer.frame = CGRectMake(10.0f, 10.0f, 250.0f, 250.0f);
  [self.layer addSublayer:layer];
}

- (IBAction)fade:(id)sender {
  [[[self.layer sublayers] objectAtIndex:0] setOpacity:0.25f];
}

- (IBAction)addSublayer:(id)sender {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [self red];
  layer.frame = CGRectMake(10.0f, 10.0f, 230.0f, 230.0f);
  [[[self.layer sublayers] objectAtIndex:0] addSublayer:layer];
}


- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
  id<CAAction> action = nil;
  if([key isEqualToString:@"opacity"]) {
    CABasicAnimation *animation = 
    [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.5f;
    action = animation;
  } else if([key isEqualToString:@"sublayers"]) {
    action = (id<CAAction>)[NSNull null];
  }
  return action;
}

@end

@implementation ActionView (Color)

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

- (CGColorRef)white {
  static CGColorRef white = NULL;
  if(white == NULL) {
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
    white = CGColorCreate([self genericRGBSpace], values);
  }
  return white;
}

- (CGColorRef)red {
  static CGColorRef red = NULL;
  if(red == NULL) {
    CGFloat values[4] = {1.0, 0.0, 0.0, 1.0};
    red = CGColorCreate([self genericRGBSpace], values);
  }
  return red;
}

@end
