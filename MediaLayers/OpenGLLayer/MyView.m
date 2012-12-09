/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyView.m
//  OpenGLLayer
//
//  Created by Bill Dudney on 11/29/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyView.h"

#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>
#import "OpenGLLayer.h"

@implementation MyView

@synthesize movingLayer;

- (OpenGLLayer *)movingLayer{
  static OpenGLLayer *movingLayer;
  if(nil == movingLayer) {
    movingLayer = [OpenGLLayer layer];
    movingLayer.frame = CGRectMake(0.0f, 0.0f, 150.0f, 150.0f);
  }
  return movingLayer;
}

- (void)awakeFromNib {
  self.layer = [CALayer layer];
  [self.layer addSublayer:self.movingLayer];
  self.wantsLayer = YES;
}

- (IBAction)toggle:(id)sender {
  self.movingLayer.animate = !self.movingLayer.animate;
}

- (void)mouseDown:(NSEvent *)event {
  NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
  self.movingLayer.position = CGPointMake(location.x, location.y);
}

@end
