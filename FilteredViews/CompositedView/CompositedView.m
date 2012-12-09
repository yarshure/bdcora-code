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

#import "CompositedView.h"
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@implementation CompositedView
- (void) applyFilter { 
  CIFilter *filter = [CIFilter filterWithName:@"CIColorBurnBlendMode" 
                                keysAndValues:nil];
  [[controls animator] setCompositingFilter:filter];
}

- (void) removeFilter {
  [[controls animator] setCompositingFilter:nil];
}
- (void)awakeFromNib {  
  [self setWantsLayer:YES];
  [self applyFilter];
}

- (IBAction)removeFilter:(id)sender {
  if(nil != [controls compositingFilter]) {
    [self removeFilter];
  }
}

- (IBAction)addFilter:(id)sender {
  if(nil == [controls compositingFilter]) {
    [self applyFilter];
  }
}

- (void)drawRect:(NSRect)rect {
  [[NSColor lightGrayColor] set];
  NSRectFill(rect);
}
@end
