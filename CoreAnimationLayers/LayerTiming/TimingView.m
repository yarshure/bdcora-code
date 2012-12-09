/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  TimingView.m
//  LayerTiming
//
//  Created by Bill Dudney on 2/5/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "TimingView.h"

@interface TimingView(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
- (CGColorRef)red;
- (CGColorRef)green;
@end

@implementation TimingView

@synthesize beachLayer, layerSpeed, layerRepeatCount, 
  layerFillMode, layerAutoreverse, layerDuration, 
  layerOffset, layerBeginTime, moveLayer;

- (void)setLayerOffset:(CGFloat)newOffset {
  [self willChangeValueForKey:@"layerOffset"];
  self.positionAnimation.timeOffset = newOffset;
  [self didChangeValueForKey:@"layerOffset"];
}

- (CGFloat)layerOffset {
  return self.positionAnimation.timeOffset;
}

- (void)setLayerDuration:(CGFloat)newDuration {
  [self willChangeValueForKey:@"layerDuration"];
  self.positionAnimation.duration = newDuration;
  [self didChangeValueForKey:@"layerDuration"];
}

- (CGFloat)layerDuration {
  return self.positionAnimation.duration;
}

- (void)setLayerAutoreverse:(BOOL)flag {
  [self willChangeValueForKey:@"layerAutoreverse"];
  self.positionAnimation.autoreverses = flag;
  [self didChangeValueForKey:@"layerAutoreverse"];
}

-(BOOL)layerAutoreverse {
  return self.positionAnimation.autoreverses;
}

- (void)setLayerFillMode:(NSString *)mode {
  [self willChangeValueForKey:@"layerFillMode"];
  self.positionAnimation.fillMode = mode;
  if(mode != kCAFillModeRemoved) {
    self.positionAnimation.removedOnCompletion = NO;
  } else {
    self.positionAnimation.removedOnCompletion = YES;
  }
  [self didChangeValueForKey:@"layerFillMode"];
}

- (NSString *)layerFillMode {
  return self.positionAnimation.fillMode;
}

- (void)setLayerSpeed:(CGFloat)newSpeed {
  [self willChangeValueForKey:@"layerSpeed"];
  self.positionAnimation.speed = newSpeed;
  [self didChangeValueForKey:@"layerSpeed"];
}

- (CGFloat)layerSpeed {
  return self.positionAnimation.speed;
}

- (void)setLayerRepeatCount:(CGFloat)newCount {
  [self willChangeValueForKey:@"repeatCount"];
  self.positionAnimation.repeatCount = newCount;
  [self didChangeValueForKey:@"repeatCount"];
}

- (CGFloat)layerRepeatCount {
  return self.positionAnimation.repeatCount;
}

- (void)moveLayer:(CALayer *)layer toPosition:(CGPoint)newPosition {
  if(moveLayer == YES) {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [layer setPosition:newPosition];
    [CATransaction commit];
  }
}

- (void)recenter {
  CGPoint center = CGPointMake(NSMidX([self bounds]), NSMidY([self bounds]));
  BOOL oldValue = moveLayer;
  moveLayer = YES;
  [self moveLayer:beachLayer toPosition:center];
  moveLayer = oldValue;
}

- (void)top {
  NSPoint top = NSMakePoint(NSMidX([self bounds]), NSMaxY([self bounds]));
  NSPoint current = NSMakePoint(self.beachLayer.position.x, self.beachLayer.position.y);
  self.positionAnimation.fromValue = [NSValue valueWithPoint:current];
  self.positionAnimation.toValue = [NSValue valueWithPoint:top];
  positionAnimation.beginTime = CACurrentMediaTime () + layerBeginTime;
  [beachLayer addAnimation:self.positionAnimation forKey:@"position"];
  [self moveLayer:beachLayer toPosition:*(CGPoint*)&top];
}

- (void)bottom {
  NSPoint bottom = NSMakePoint(NSMidX([self bounds]), NSMinY([self bounds]));
  NSPoint current = NSMakePoint(self.beachLayer.position.x, self.beachLayer.position.y);
  self.positionAnimation.fromValue = [NSValue valueWithPoint:current];
  self.positionAnimation.toValue = [NSValue valueWithPoint:bottom];
  positionAnimation.beginTime = CACurrentMediaTime () + layerBeginTime;
  [beachLayer addAnimation:self.positionAnimation forKey:@"position"];
  [self moveLayer:beachLayer toPosition:*(CGPoint*)&bottom];
}

- (void)left {
  NSPoint left = NSMakePoint(NSMinX([self bounds]), NSMidY([self bounds]));
  NSPoint current = NSMakePoint(self.beachLayer.position.x, self.beachLayer.position.y);
  self.positionAnimation.fromValue = [NSValue valueWithPoint:current];
  self.positionAnimation.toValue = [NSValue valueWithPoint:left];
  positionAnimation.beginTime = CACurrentMediaTime () + layerBeginTime;
  [beachLayer addAnimation:self.positionAnimation forKey:@"position"];
  [self moveLayer:beachLayer toPosition:*(CGPoint*)&left];
}

- (void)right {
  NSPoint right = NSMakePoint(NSMaxX([self bounds]), NSMidY([self bounds]));
  NSPoint current = NSMakePoint(self.beachLayer.position.x, self.beachLayer.position.y);
  self.positionAnimation.fromValue = [NSValue valueWithPoint:current];
  self.positionAnimation.toValue = [NSValue valueWithPoint:right];
  positionAnimation.beginTime = CACurrentMediaTime () + layerBeginTime;
  [beachLayer addAnimation:self.positionAnimation forKey:@"position"];
  [self moveLayer:beachLayer toPosition:*(CGPoint*)&right];
}

- (CABasicAnimation *)positionAnimation { 
  if(nil == positionAnimation) {
    positionAnimation = [[CABasicAnimation animationWithKeyPath:@"position"] retain];
  }
  return positionAnimation;
}

- (CGImageRef)imageNamed:(NSString *)name ofType:(NSString *)type {
  CGImageRef image = NULL;
  NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                   ofType:type];
  NSURL *beachURL = [NSURL fileURLWithPath:path];
  CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)beachURL, NULL);
  if(NULL != src) {
    image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
    CFRelease(src);
  }
  return image;
}

- (CGImageRef)beach {
  if(beach == NULL) {
    beach = [self imageNamed:@"beach" ofType:@"jpg"];
  }
  return beach;
}

- (CALayer *)beachLayer {
  if(nil == beachLayer) {
    beachLayer = [CALayer layer];
    beachLayer.contents = (id)[self beach];
    beachLayer.bounds = CGRectMake(0.0f, 0.0f, 160.0, 120.0f);
    beachLayer.position = CGPointMake(NSMidX([self bounds]),
                                      NSMidY([self bounds]));
    beachLayer.name = @"beach";
    [self setLayerSpeed:1.0f];
    [self setLayerRepeatCount:0.0f];
  }
  return beachLayer;
}

- (void)moveUp:(id)sender {
  [self top];
}

- (void)moveDown:(id)sender {
  [self bottom];
}

- (void)moveLeft:(id)sender {
  [self left];
}

- (void)moveRight:(id)sender {
  [self right];
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  self.layer.backgroundColor = [self black];
  [self setWantsLayer:YES];
  [self.layer addSublayer:self.beachLayer];
  [[self window] makeFirstResponder:self];
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

@end

@implementation TimingView (Color)

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

- (CGColorRef)red {
  static CGColorRef red = NULL;
  if(red == NULL) {
    CGFloat values[4] = {1.0, 0.0, 0.0, 1.0};
    red = CGColorCreate([self genericRGBSpace], values);
  }
  return red;
}

- (CGColorRef)green {
  static CGColorRef green = NULL;
  if(green == NULL) {
    CGFloat values[4] = {0.0, 1.0, 0.0, 1.0};
    green = CGColorCreate([self genericRGBSpace], values);
  }
  return green;
}

@end
