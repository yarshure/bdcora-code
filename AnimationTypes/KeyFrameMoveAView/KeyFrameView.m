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

#import "KeyFrameView.h"

@implementation KeyFrameView

@synthesize heartPath;

- (void)setFrameOrigin:(NSPoint)newOrigin {
  NSLog(@"setting new origin");
  [super setFrameOrigin:newOrigin];
}

- (void)addBounceAnimation { 
  [mover setAnimations:[NSDictionary dictionaryWithObjectsAndKeys:
                        self.originAnimation, @"frameOrigin", nil]];
}

- (id)initWithFrame:(NSRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
    // inset by 3/8's
    CGFloat xInset = 3.0f * (NSWidth(frame) / 8.0f);
    CGFloat yInset = 3.0f * (NSHeight(frame) / 8.0f);
    NSRect moverFrame = NSInsetRect(frame, xInset, yInset);
    mover = [[NSImageView alloc] initWithFrame:moverFrame];
    [mover setImageScaling:NSScaleToFit];
    [mover setImage:[NSImage imageNamed:@"photo.jpg"]];
    [self addSubview:mover];
    [self addBounceAnimation]; 
  }
  return self;
}

- (CGPathRef)heartPath {
  NSRect frame = [mover frame];
  if(heartPath == NULL) {
    heartPath = CGPathCreateMutable();
    CGPathMoveToPoint(heartPath, NULL, NSMinX(frame), NSMinY(frame));
    CGPathAddLineToPoint(heartPath, NULL, NSMinX(frame) - NSWidth(frame), 
                         NSMinY(frame) + NSHeight(frame) * 0.85);
    CGPathAddLineToPoint(heartPath, NULL, NSMinX(frame), 
                         NSMinY(frame) - NSHeight(frame) * 1.5);
    CGPathAddLineToPoint(heartPath, NULL, NSMinX(frame) + NSWidth(frame), 
                         NSMinY(frame) + NSHeight(frame) * 0.85);
    CGPathAddLineToPoint(heartPath, NULL, NSMinX(frame), NSMinY(frame));
    CGPathCloseSubpath(heartPath);
  }
  return heartPath;
}    

- (CAKeyframeAnimation *)originAnimation { 
  CAKeyframeAnimation *originAnimation = [CAKeyframeAnimation animation];
  originAnimation.path = self.heartPath; 
  originAnimation.duration = 2.0f;
  originAnimation.calculationMode = kCAAnimationPaced;
  return originAnimation;
}

- (BOOL)acceptsFirstResponder { 
  return YES;
}

- (void)keyDown:(NSEvent *)event { 
  [self bounce];
}

- (void)bounce { 
  NSRect rect = [mover frame];
  [[mover animator] setFrameOrigin:rect.origin];
}

- (void)drawRect:(NSRect)dirtyRect {
  CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
  CGContextAddPath(ctx, [self heartPath]);
  CGContextStrokePath(ctx);
}

@end
