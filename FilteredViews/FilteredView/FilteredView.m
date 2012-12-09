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
//  Copyright 2007 Bill Dudney. All rights reserved.
//

#import "FilteredView.h"
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@implementation FilteredView

- (void)awakeFromNib {
  [controls setWantsLayer:YES];
}

- (void)pointillize { 
  CIVector *center = [CIVector vectorWithX:NSMidX([self bounds]) 
                                         Y:NSMidY([self bounds])];
  CIFilter *pointillize = [CIFilter 
                          filterWithName:@"CIPointillize" 
                          keysAndValues:kCIInputRadiusKey, 
                          [NSNumber numberWithFloat:1.0f],
                          kCIInputCenterKey, center, nil];
  pointillize.name = @"pointillize";
  [controls setContentFilters:[NSArray arrayWithObjects:pointillize, nil]];
}

- (IBAction)noPointillize:(id)sender {
  if(0 < [[controls contentFilters] count]) {
    [controls setContentFilters:nil];
  }
}

- (IBAction)heavyPointillize:(id)sender { 
  if(nil == [controls contentFilters] ||
     0 == [[controls contentFilters] count]) {
    [self pointillize];
  }
  NSString *path = [NSString stringWithFormat:
                    @"contentFilters.pointillize.%@", kCIInputRadiusKey];
  [controls setValue:[NSNumber numberWithInt:5.0f] forKeyPath:path];
}

- (IBAction)lightPointillize:(id)sender { 
  if(nil == [controls contentFilters] || 
     0 == [[controls contentFilters] count]) {
    [self pointillize];
  }
  NSString *path = [NSString stringWithFormat:
                    @"contentFilters.pointillize.%@", kCIInputRadiusKey];
  [controls setValue:[NSNumber numberWithInt:1.0f] 
          forKeyPath:path];
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
