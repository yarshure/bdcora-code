/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyController.m
//  CustomizeAnimation
//
//  Created by Bill Dudney on 11/2/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyController.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseView.h"

@implementation MyController

- (IBAction)makeSlow:(id)sender { 
  CABasicAnimation *frameOriginAnimation = [CABasicAnimation animation];
  [frameOriginAnimation setDuration:2.0f];
  NSDictionary *animations = [NSDictionary dictionaryWithObjectsAndKeys:
                              frameOriginAnimation, @"frameOrigin", nil];
  [myView.mover setAnimations:animations];
}

- (IBAction)makeDefault:(id)sender { 
  [myView.mover setAnimations:nil];
}

- (IBAction)makeFast:(id)sender { 
  CABasicAnimation *frameOriginAnimation = [CABasicAnimation animation];
  [frameOriginAnimation setDuration:0.1f];
  NSDictionary *animations = [NSDictionary dictionaryWithObjectsAndKeys:
                              frameOriginAnimation, @"frameOrigin",nil];
  [myView.mover setAnimations:animations];
}

@end

