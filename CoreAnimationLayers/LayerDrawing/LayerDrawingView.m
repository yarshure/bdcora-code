/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  LayerDrawingView.m
//  LayerDrawing
//
//  Created by Bill Dudney on 2/12/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "LayerDrawingView.h"

@interface LayerDrawingView(Color)
- (CGColorRef)black;
- (CGColorRef)white;
@end

@implementation LayerDrawingView

- (CALayer *)drawingLayer {
  if(nil == drawingLayer) {
    drawingLayer = [CALayer layer];
    [drawingLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [drawingLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
    [drawingLayer setValue:[NSNumber numberWithFloat:NSWidth([self bounds]) * 0.85] forKeyPath:@"bounds.size.width"];
    [drawingLayer setValue:[NSNumber numberWithFloat:NSHeight([self bounds]) * 0.85] forKeyPath:@"bounds.size.height"];
  }
  return drawingLayer;
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  [self setWantsLayer:YES];
  self.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
  self.layer.backgroundColor = [self black];
  self.drawingLayer.delegate = self; 
  [self.drawingLayer setNeedsDisplay]; 
  NSUInteger resizeMask =  kCALayerWidthSizable | kCALayerHeightSizable;
  self.drawingLayer.autoresizingMask = resizeMask; 
  self.drawingLayer.needsDisplayOnBoundsChange = YES; 
  [self.layer addSublayer:self.drawingLayer];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  CGContextSaveGState(ctx);
  CGContextSetLineWidth(ctx, 4.0f);
  CGContextSetStrokeColorWithColor(ctx, [self white]);
  CGContextStrokeRect(ctx, CGRectInset(layer.bounds, CGRectGetWidth(layer.bounds) * 0.05, CGRectGetHeight(layer.bounds) * 0.05));
  CGContextRestoreGState(ctx);
}

@end

@implementation LayerDrawingView (Color)

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

@end
