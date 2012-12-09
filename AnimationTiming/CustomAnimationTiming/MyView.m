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
//  CustomAnimationTiming
//
//  Created by Bill Dudney on 12/18/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyView.h"

@implementation MyView
-(void)setupMover {
  NSRect bounds = self.bounds;
  NSRect moverFrame =
  NSInsetRect(bounds, NSWidth(bounds) / 4.0f,
              NSHeight(bounds) / 4.0f);
  moverFrame.origin.x = 0.0f;
	mover = [[NSImageView alloc] initWithFrame:moverFrame];
	[mover setImageScaling:NSScaleToFit];
	[mover setImage:[NSImage imageNamed:@"photo.jpg"]];
  [self addSubview:mover];
}
- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupMover];
  }
  return self;
}

- (CABasicAnimation *)moveAnimation {
  if(nil == moveAnimation) {
    moveAnimation = [CABasicAnimation animation];
    moveAnimation.duration = 2.0f;
    moveAnimation.timingFunction = 
    [[CAMediaTimingFunction alloc] 
     initWithControlPoints:0.5 :1.0 :0.5 :0.0];
  }
  return moveAnimation;
}
- (void)move {
  NSDictionary *animations = [NSDictionary 
                              dictionaryWithObject:[self moveAnimation]
                              forKey:@"frameOrigin"];
  [mover setAnimations:animations];
  NSPoint origin = mover.frame.origin;
  origin.x += NSWidth(mover.frame);
  [mover.animator setFrameOrigin:origin];
}

- (BOOL)acceptsFirstResponder {
  return YES;
}
- (void)keyDown:(NSEvent *)event {
  [self move];
}

@end
