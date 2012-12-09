/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  TimingView.h
//  LayerTiming
//
//  Created by Bill Dudney on 2/5/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface TimingView : NSView {
  CGImageRef beach;
  CALayer *beachLayer;
  CABasicAnimation *positionAnimation;
  CGFloat layerBeginTime;
  BOOL moveLayer;
}

@property(readonly) CGImageRef beach;
@property(readonly) CALayer *beachLayer;
@property(readonly) CABasicAnimation *positionAnimation;
@property(assign) CGFloat layerSpeed;
@property(assign) CGFloat layerRepeatCount;
@property(retain) NSString *layerFillMode;
@property(assign) BOOL layerAutoreverse;
@property(assign) BOOL moveLayer;
@property(assign) CGFloat layerDuration;
@property(assign) CGFloat layerOffset;
@property(assign) CGFloat layerBeginTime;

- (void)top;
- (void)bottom;
- (void)left;
- (void)right;  
- (void)recenter;

@end
