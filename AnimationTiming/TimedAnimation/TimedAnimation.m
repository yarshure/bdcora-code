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

#import "TimedAnimation.h"

@implementation TimedAnimation

- (id)initWithFrame:(NSRect)newFrame { 
  self = [super initWithFrame:newFrame];
  if (self) {
    CGFloat xInset = NSWidth(newFrame) / 3.0f;
    CGFloat yInset = NSHeight(newFrame) / 3.0f;
    NSRect frame = NSInsetRect(newFrame, xInset, yInset);
    // photo1 starts at the left edge
    frame.origin.x = 0.0f;
    frame.origin.y = NSMidY([self bounds]) - (NSHeight(frame) / 2.0f);
    photo1 = [[NSImageView alloc] initWithFrame:frame];
    [photo1 setImageScaling:NSScaleToFit];
    [photo1 setImage:[NSImage imageNamed:@"photo1.jpg"]];
    [self addSubview:photo1];
    // photo2 starts in the center
    frame.origin.x = NSMidX([self bounds]) - (NSWidth(frame) / 2.0f);
    photo2 = [[NSImageView alloc] initWithFrame:frame];
    [photo2 setImageScaling:NSScaleToFit];
    [photo2 setImage:[NSImage imageNamed:@"photo2.jpg"]];
    [self addSubview:photo2];
  }
  return self;
}

- (CABasicAnimation *)basicAnimationNamed:(NSString *)name 
                                 duration:(CGFloat)duration { 
  CABasicAnimation *animation = [CABasicAnimation animation];
  animation.duration = duration;
  [animation setValue:name forKey:@"name"];
  return animation;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)event {
  if([[event characters] characterAtIndex:0] == NSRightArrowFunctionKey) {
    [self right];
  } else if([[event characters] characterAtIndex:0] == 'r') {
    [self reset];
  } else {
    [super keyDown:event];
  }
}

- (void)right { 
  // photo1 is going to move to where photo2 is
  NSPoint newOrigin = [photo2 frame].origin;
  CABasicAnimation *animation = 
  [self basicAnimationNamed:@"photo1" duration:1.0f]; 
  animation.delegate = self; 
  [photo1 setAnimations:
   [NSDictionary dictionaryWithObject:animation 
                               forKey:@"frameOrigin"]];
  [[photo1 animator] setFrameOrigin:newOrigin];
}
- (void) reset { 
  [photo1 setAnimations:nil];
  [photo2 setAnimations:nil];
  
  NSPoint newPhoto1Origin = NSMakePoint(0.0f, NSMidY([self frame]) - 
                                        (NSHeight([photo1 bounds]) / 2.0f));
  NSPoint newPhoto2Origin = 
  NSMakePoint(NSMidX([self frame]) - (NSWidth([photo2 bounds]) / 2.0f),  
              NSMidY([self frame]) - (NSHeight([photo2 bounds]) / 2.0f));
  [[photo1 animator] setFrameOrigin:newPhoto1Origin];
  [[photo2 animator] setFrameOrigin:newPhoto2Origin];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag { 
  if(flag && [[animation valueForKey:@"name"] isEqual:@"photo1"]) {
    CABasicAnimation *photo2Animation = 
    [self basicAnimationNamed:@"photo2" duration:animation.duration];
    [photo2 setAnimations:[NSDictionary dictionaryWithObject:photo2Animation 
                                                      forKey:@"frameOrigin"]];
    NSPoint newPhoto2Origin = 
    NSMakePoint(NSMaxX([self frame]) - [photo2 frame].size.width, 
                [photo2 frame].origin.y);
    [[photo2 animator] setFrameOrigin:newPhoto2Origin];
  }
}

@end
