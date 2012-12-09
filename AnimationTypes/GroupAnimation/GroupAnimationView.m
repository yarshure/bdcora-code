/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  Created by Bill Dudney on 10/16/07.
//  Copyright 2007 Bill Dudney. All rights reserved.
//

#import "GroupAnimationView.h"

@implementation GroupAnimationView

- (CAAnimation *)frameAnimation:(NSRect)aniFrame {  
  CAKeyframeAnimation *frameAnimation = 
  [CAKeyframeAnimation animationWithKeyPath:@"frame"];
  NSRect start = aniFrame;
  NSRect end = NSInsetRect(aniFrame, -NSWidth(start) * 0.50,
                           -NSHeight(start) * 0.50);
  frameAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithRect:start],
                           [NSValue valueWithRect:end], nil];
  return frameAnimation;
}

- (CABasicAnimation *)rotationAnimation {  
  CABasicAnimation *rotation = 
  [CABasicAnimation animationWithKeyPath:@"frameRotation"];
  rotation.fromValue = [NSNumber numberWithFloat:0.0f];
  rotation.toValue = [NSNumber numberWithFloat:45.0f];
  return rotation;
}

- (CAAnimationGroup *)groupAnimation:(NSRect)frame {  
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = [NSArray arrayWithObjects:
                      [self frameAnimation:frame], 
                      [self rotationAnimation], nil];
  group.duration = 1.0f;
  group.autoreverses = YES;
  return group;
}


- (id)initWithFrame:(NSRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
    // inset by 3/8's
    CGFloat xInset = 3.0f * (NSWidth(frame) / 8.0f);
    CGFloat yInset = 3.0f * (NSHeight(frame) / 8.0f);
    NSRect moverFrame = NSInsetRect(frame, xInset, yInset);
    moverFrame.origin.x = NSMidX([self bounds]) - 
    (NSWidth(moverFrame) / 2.0f);
    moverFrame.origin.y = NSMidY([self bounds]) - 
    (NSHeight(moverFrame) / 2.0f);
    mover = [[NSImageView alloc] initWithFrame:moverFrame];
    [mover setImageScaling:NSScaleToFit];
    [mover setImage:[NSImage imageNamed:@"photo.jpg"]];
    NSDictionary *animations = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [self groupAnimation:moverFrame], @"frameRotation", nil];
    [mover setAnimations:animations];
    [self addSubview:mover];
  }
  return self;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)event {
  [[mover animator] setFrameRotation:[mover frameRotation]];
}

@end
