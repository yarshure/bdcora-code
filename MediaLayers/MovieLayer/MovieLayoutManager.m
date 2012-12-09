/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MovieLayoutManager.m
//  MovieLayer
//
//  Created by Bill Dudney on 2/15/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MovieLayoutManager.h"


@implementation MovieLayoutManager

@synthesize slowMoFlag;

+ (id)layoutManager {
  return [[[self alloc] init] autorelease];
}

- (id)init {
  self = [super init];
  spacing = 10.0f;
  contentFilter = [CIFilter filterWithName:@"CISepiaTone"];
  [contentFilter setDefaults];
  blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"
                          keysAndValues:kCIInputRadiusKey, 
                [NSNumber numberWithFloat:5.0f], nil];
  return self;
}

- (CGSize)sizeForHolder:(CALayer *)holderLayer {
  CALayer *movieLayer = [holderLayer valueForKey:@"movieLayer"];
  CALayer *nameLayer = [holderLayer valueForKey:@"nameLayer"];
  CGSize holderSize;
  // always the width of the movie
  holderSize.width = [movieLayer preferredFrameSize].width;
  holderSize.height = [movieLayer preferredFrameSize].height + 
  [nameLayer preferredFrameSize].height + 10.0f;
  return holderSize;
}


- (void)layoutSublayersOfLayer:(CALayer *)layer {
  NSInteger sublayerCount = [layer.sublayers count];
  if(sublayerCount == 0) {
    return;
  }
  if(slowMoFlag) {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:3.0f]
                     forKey:kCATransactionAnimationDuration];
  }
  CGFloat circumference = sublayerCount * spacing;
  for(CALayer *sublayer in layer.sublayers) {
    circumference += CGRectGetWidth([(CALayer *)[sublayer valueForKey:@"movieLayer"] bounds]);
  }
  
  // platter radius -> minimum of 400
  CGFloat platterRadius = circumference / (2.0f * M_PI);
  platterRadius = platterRadius > 400.0f ? platterRadius : 400.0f;
  
  // the center of the platter
  CGFloat platterXCenter = CGRectGetMidX(layer.bounds);
  CGFloat platterYCenter = CGRectGetMidY(layer.bounds);
  CGFloat platterZCenter = 0.0f;
  
  CGFloat angleDelta = (2.0f * M_PI) / sublayerCount;
  
  NSInteger selectedIndex = [[layer valueForKey:@"selectedIndex"] intValue];
  // reused transforms
  CATransform3D platterCenterTranslate = 
  CATransform3DMakeTranslation(platterXCenter, platterYCenter, platterZCenter);
  CATransform3D platterRadiusTranslate = 
  CATransform3DMakeTranslation(0.0f, 0.0f, platterRadius);
  NSInteger counter = 0;
  for(counter = 0;counter < sublayerCount;counter++) {
    NSInteger index = (selectedIndex + counter) % sublayerCount;
    CALayer *sublayer = [layer.sublayers objectAtIndex:index];
    if(index != selectedIndex && nil == sublayer.filters) {
      sublayer.filters = [NSArray arrayWithObjects:contentFilter, blurFilter, nil];
    }
    if(index == selectedIndex) {
      sublayer.filters = nil;
    }
    // properly set the size
    CGSize sublayerSize = [self sizeForHolder:sublayer];
    sublayer.bounds = CGRectMake(0.0f, 0.0f, sublayerSize.width, sublayerSize.height);
    // calc the transform
    CGFloat angle = counter * angleDelta;
    CATransform3D yRotation = CATransform3DMakeRotation(angle, 0.0f, 1.0f, 0.0f);
    CATransform3D intermediate = CATransform3DConcat(yRotation, platterCenterTranslate);
    intermediate = CATransform3DConcat(platterRadiusTranslate, intermediate);
    // reverse the angle distortion
    intermediate = 
    CATransform3DConcat(CATransform3DMakeRotation(-angle, 0.0f, 1.0f, 0.0f), intermediate);
    // apply the transform to move the layer
    sublayer.transform = intermediate;
    if(index != selectedIndex) {
      // m43 is the z-translation
      CGFloat scale = 0.10 * ((platterRadius + intermediate.m43) / (2.0f * platterRadius)) + 0.5;
      sublayer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1.0f);
      sublayer.opacity = 1.0f;
    } else {
      sublayer.opacity = 1.0f;
      sublayer.sublayerTransform = CATransform3DIdentity;
    }
  }
  if(slowMoFlag) {
    [CATransaction commit];
    self.slowMoFlag = NO;
  }
}

@end
