/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  Platter3DLayoutManager.m
//  Platter
//
//  Created by Bill Dudney on 1/21/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "Platter3DLayoutManager.h"

@implementation Platter3DLayoutManager

+ (id)layoutManager {
  return [[[self alloc] init] autorelease];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
  CGFloat platterRadius = 600.0f; 
 
  NSNumber *selectedItemIndex = [layer valueForKey:@"selectedItem"];
  NSInteger selectedItemIndexInt = [selectedItemIndex intValue];
  
  CGFloat platterXCenter = (layer.bounds.size.width * 3.0f/4.0f) - 
  platterRadius;
  CGFloat platterYCenter = layer.bounds.size.height / 2.0f;
  
  CATransform3D platterCenterTranslate = 
  CATransform3DMakeTranslation(platterXCenter, platterYCenter, 0.0f);
  
  CATransform3D platterRadiusTranslate = 
  CATransform3DMakeTranslation(platterRadius, 0.0f, 0.0f);
  
  CGFloat xRotationAngle = 2.5f * M_PI/180.0f;
  
  CATransform3D xRotation = 
  CATransform3DMakeRotation(xRotationAngle, 1.0f, 0.0f, 0.0f);
  
  NSInteger index = 0;
  for(index = 0;index < [[layer sublayers] count];index++) { 
    NSInteger offset = index - selectedItemIndexInt; 
    CALayer *sublayer = [[layer sublayers] objectAtIndex:index];
    CGFloat angle = offset * 360.0f/7.0f  * M_PI/180.f;
    CATransform3D yRotation = 
    CATransform3DMakeRotation(angle, 0.0f, 1.0f, 0.0f);
    CATransform3D intermediate = 
    CATransform3DConcat(xRotation, platterCenterTranslate);
    intermediate = CATransform3DConcat(yRotation, intermediate); 
    intermediate = CATransform3DConcat(platterRadiusTranslate, intermediate); 
    CATransform3D minusYRotation =  
    CATransform3DMakeRotation(-angle, 0.0f, 1.0f, 0.0f);
    sublayer.transform = CATransform3DConcat(minusYRotation, intermediate);  
  }
  
  NSInteger forwardIndex = (selectedItemIndexInt + 6) % 7;  
  CALayer *forwardLayer = [[layer sublayers] objectAtIndex:forwardIndex];
  CATransform3D scale = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
  forwardLayer.transform = CATransform3DConcat(scale, forwardLayer.transform);
  
  NSInteger backwardIndex = (selectedItemIndexInt + 1) % 7;
  CALayer *backwardLayer = [[layer sublayers] objectAtIndex:backwardIndex];
  scale = CATransform3DMakeScale(0.8f, 0.8f, 1.0f);
  backwardLayer.transform = CATransform3DConcat(scale, backwardLayer.transform);
}

@end
