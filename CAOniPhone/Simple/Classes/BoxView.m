/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  BoxView.m
//  SimpleBox
//
//  Created by Bill Dudney on 3/19/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "BoxView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BoxView

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
  id<CAAction> animation = nil;
  if([key isEqualToString:@"position"]) {
    animation = [CABasicAnimation animation];
    ((CABasicAnimation*)animation).duration = 1.0f;
  } else {
    animation = [super actionForLayer:layer forKey:key];
  }
  return animation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = touches.anyObject;
  CGPoint newCenter = [touch locationInView:self.superview];
  [UIView beginAnimations:@"center" context:nil];
  self.center = newCenter;
  [UIView commitAnimations];
}

@end

