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
//  CustomizeAnimation
//
//  Created by Bill Dudney on 11/1/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView

@synthesize drawnLineWidth;
@synthesize path;

- (id)initWithFrame:(NSRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
    drawnLineWidth = 1.0f;
    path = [[NSBezierPath alloc] init];
    [path moveToPoint:[self bounds].origin];
    [path lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
  }
  return self;
}

- (void)awakeFromNib {
  [slider setFloatValue:drawnLineWidth];
}

- (void)drawRect:(NSRect)rect { 
  [[NSColor blueColor] setStroke];
  [self.path stroke];
}

- (IBAction)setWidth:(id)sender { 
  [[self animator] setDrawnLineWidth:[sender floatValue]];
}

- (void)setDrawnLineWidth:(float)value { 
  [self willChangeValueForKey:@"drawnLineWidth"];
  drawnLineWidth = value;
  [self.path setLineWidth:drawnLineWidth];
  [self setNeedsDisplay:YES]; 
  [self didChangeValueForKey:@"drawnLineWidth"];
}

+ (id)defaultAnimationForKey:(NSString *)key { 
  static CABasicAnimation *drawnLineWidthBasicAnimation = nil;
  if ([key isEqualToString:@"drawnLineWidth"]) {
    if (drawnLineWidthBasicAnimation == nil) {
      drawnLineWidthBasicAnimation = [[CABasicAnimation alloc] init];
    }
    return drawnLineWidthBasicAnimation;
  } else {
    return [super defaultAnimationForKey:key];
  }
}

@end
