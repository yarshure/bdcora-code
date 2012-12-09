/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  TimingController.m
//  LayerTiming
//
//  Created by Bill Dudney on 2/6/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "TimingController.h"
#import "TimingView.h"

#define kFillModeRemoved 0
#define kFillModeForwards 1
#define kFillModeBackwards 2
#define kFillModeBoth 3

@implementation TimingController

@synthesize timingView, layerSpeed, layerRepeatCount, 
layerFillMode, layerAutoreverse, layerDuration, 
layerOffset, layerBeginTime, moveLayer;

- (void)awakeFromNib {
  fillModeNames = [[NSArray arrayWithObjects:kCAFillModeRemoved, 
                    kCAFillModeForwards, 
                    kCAFillModeBackwards, 
                    kCAFillModeBoth, nil] retain];
  [self setLayerFillMode:1];
}

- (void)setMoveLayer:(BOOL)flag {
  [self willChangeValueForKey:@"moveLayer"];
  self.timingView.moveLayer = flag;
  [self didChangeValueForKey:@"moveLayer"];
}

- (BOOL)moveLayer {
  return self.timingView.moveLayer;
}

- (void)setLayerBeginTime:(CGFloat)newBegin {
  [self willChangeValueForKey:@"layerBeginTime"];
  self.timingView.layerBeginTime = newBegin;
  [self didChangeValueForKey:@"layerBeginTime"];
}

- (CGFloat)layerBeginTime {
  return self.timingView.layerBeginTime;
}

- (void)setLayerOffset:(CGFloat)newOffset {
  [self willChangeValueForKey:@"layerOffset"];
  self.timingView.layerOffset = newOffset;
  [self didChangeValueForKey:@"layerOffset"];
}

- (CGFloat)layerOffset {
  return self.timingView.layerOffset;
}

-(void)setLayerDuration:(CGFloat)newDuration {
  [self willChangeValueForKey:@"layerDuration"];
  self.timingView.layerDuration = newDuration;
  [self didChangeValueForKey:@"layerDuration"];
}

- (CGFloat)layerDuration {
  return self.timingView.layerDuration;
}

- (void)setLayerAutoreverse:(BOOL)flag {
  [self willChangeValueForKey:@"autoreverse"];
  self.timingView.layerAutoreverse = flag;
  [self didChangeValueForKey:@"autoreverse"];
}

- (BOOL)layerAutoreverse {
  return self.timingView.layerAutoreverse;
}

- (void)setLayerFillMode:(NSInteger)newMode  {
  [self willChangeValueForKey:@"fillMode"];
  layerFillMode = newMode;
  self.timingView.layerFillMode = [fillModeNames objectAtIndex:newMode];
  [self didChangeValueForKey:@"fillMode"];
}

- (NSInteger)layerFillMode {
  return [fillModeNames indexOfObject:[self.timingView layerFillMode]];
}

- (void)setLayerSpeed:(CGFloat)newSpeed {
  [self willChangeValueForKey:@"layerSpeed"];
  self.timingView.layerSpeed = newSpeed;
  [self didChangeValueForKey:@"layerSpeed"];
}

- (CGFloat)layerSpeed {
  return self.timingView.layerSpeed;
}

- (void)setLayerRepeatCount:(CGFloat)newCount {
  [self willChangeValueForKey:@"repeatCount"];
  self.timingView.layerRepeatCount = newCount;
  [self didChangeValueForKey:@"repeatCount"];
}

- (CGFloat)layerRepeatCount {
  return self.timingView.layerRepeatCount;
}

- (IBAction)recenter:(id)sender {
  [self.timingView recenter];
}

- (IBAction)top:(id)sender {
  [self.timingView top];
}
- (IBAction)bottom:(id)sender {
  [self.timingView bottom];
}
- (IBAction)left:(id)sender {
  [self.timingView left];
}
- (IBAction)right:(id)sender {
  [self.timingView right];
}

@end
