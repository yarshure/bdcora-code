/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MoverView.h
//  MoveAView
//
//  Created by Bill Dudney on 10/16/07.
//  Copyright 2007 Bill Dudney. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface GroupAnimationView : NSView {
  NSImageView *mover;
}
- (CAAnimation *)frameAnimation:(NSRect)aniFrame;
- (CABasicAnimation *)rotationAnimation;
- (CAAnimationGroup *)groupAnimation:(NSRect)frame;

@end
