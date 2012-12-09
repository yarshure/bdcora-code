/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyView.h
//  AnimationTypes
//
//  Created by Bill Dudney on 1/16/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface MyView : NSView {
  CGMutablePathRef heartPath;
  CGImageRef beach;
  CAKeyframeAnimation *positionAnimation;
  CALayer *photoLayer;
}

@property(readonly) CGMutablePathRef heartPath;
@property(readonly) CAKeyframeAnimation *positionAnimation;
@property(readonly) CGImageRef beach;
@property(readonly) CALayer *photoLayer;

- (void)bounce;

- (IBAction)stop:(id)sender;
- (IBAction)moveBottomLeft:(id)sender;
- (IBAction)moveTopRight:(id)sender;

@end
