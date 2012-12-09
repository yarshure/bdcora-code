/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  FilteredView.m
//  FilteredView
//
//  Created by Bill Dudney on 11/19/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "BackgroundFilteredView.h"
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@implementation BackgroundFilteredView

- (void) addAnimationToTorusFilter { 
  NSString *keyPath = [NSString stringWithFormat:
                       @"backgroundFilters.torus.%@",
                       kCIInputWidthKey];
  CABasicAnimation *animation = [CABasicAnimation 
                                 animationWithKeyPath:keyPath];
  animation.fromValue = [NSNumber numberWithFloat:50.0f];
  animation.toValue = [NSNumber numberWithFloat:80.0f];
  animation.duration = 1.0;
  animation.repeatCount = 1e100f;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:
                              kCAMediaTimingFunctionEaseInEaseOut];
  animation.autoreverses = YES;
  [[controls layer] addAnimation:animation forKey:@"torusAnimation"];
}

- (void) applyFilter { 
  CIVector *center = [CIVector 
                      vectorWithX:NSMidX([self bounds]) 
                      Y:NSMidY([self bounds])];
  CIFilter *torus = [CIFilter filterWithName:@"CITorusLensDistortion" 
                               keysAndValues:kCIInputCenterKey, center, 
                     kCIInputRadiusKey, [NSNumber numberWithFloat:150.0f], 
                     kCIInputWidthKey, [NSNumber numberWithFloat:2.0f], 
                     kCIInputRefractionKey, [NSNumber numberWithFloat:1.7f], 
                     nil];
  torus.name = @"torus"; 
  
  [controls setBackgroundFilters:[NSArray arrayWithObjects:torus, nil]];
  [self addAnimationToTorusFilter];
}

- (void) removeFilter {
  [controls setBackgroundFilters:nil];
}

- (void)awakeFromNib {  
  [self setWantsLayer:YES];
  [self applyFilter];
}

- (IBAction)removeFilter:(id)sender {
  if(nil != [controls backgroundFilters] || [[self backgroundFilters] count] >= 0) {
    [self removeFilter];
  }
}

- (IBAction)addFilter:(id)sender {
  if(nil == [controls backgroundFilters] || [[self backgroundFilters] count] == 0) {
    [self applyFilter];
  }
}

- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  NSSize stripeSize = bounds.size;
  stripeSize.width = NSWidth(bounds) / 10.0f;
  NSRect stripe = bounds;
  stripe.size = stripeSize;
  NSColor *colors[2] = {[NSColor whiteColor], [NSColor blueColor]};
  int i = 0;
  for(i = 0;i < 10;i++) {
    [colors[i %2] set];
    NSRectFill(stripe);
    stripe.origin.x += stripe.size.width;
  }        
}

@end
