/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyLayer.m
//  CustomProperties
//
//  Created by Bill Dudney on 5/20/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MyLayer.h"

@interface MyLayer(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
@end

@implementation MyLayer

@synthesize lineWidth;

+ (id<CAAction>)defaultActionForKey:(NSString *)aKey {
  id<CAAction> action = [super defaultActionForKey:aKey];
  // this method is only called for the existing layer properties
  // since we are redrawing the 'contents' is being replaced so we can animate
  // the replacement
  if(nil == action && [@"contents" isEqualToString:aKey]) {
    action = [CABasicAnimation animationWithKeyPath:aKey];
    ((CABasicAnimation*)action).duration = 2.0f;
  }
  return action;
}

- (id)init {
  self = [super init];
  self.lineWidth = 2.0f;
  return self;
}

- (void)setLineWidth:(CGFloat)width {
  [self willChangeValueForKey:@"lineWidth"];
  lineWidth = width;
  [self setNeedsDisplay];
  [self didChangeValueForKey:@"lineWidth"];
}

-(void)drawInContext:(CGContextRef)ctx {
  CGContextSaveGState(ctx);
  CGContextSetLineWidth(ctx, self.lineWidth);
  CGContextSetStrokeColorWithColor(ctx, [self blue]);
  CGContextMoveToPoint(ctx, 0.0f, 0.0f);
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.bounds), 
                          CGRectGetMaxY(self.bounds));
  CGContextStrokePath(ctx);
  CGContextRestoreGState(ctx);
}

@end

@implementation MyLayer(Color)

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

- (CGColorRef)white{
  static CGColorRef white = NULL;
  if(white == NULL) {
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
    white = CGColorCreate([self genericRGBSpace], values);
  }
  return white;
}

- (CGColorRef)blue {
  static CGColorRef blue = NULL;
  if(blue == NULL) {
    CGFloat values[4] = {0.0, 0.0, 1.0, 1.0};
    blue = CGColorCreate([self genericRGBSpace], values);
  }
  return blue;
}

@end
