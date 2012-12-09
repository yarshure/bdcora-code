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
//  AnimationTypes
//
//  Created by Bill Dudney on 1/16/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MyView.h"

@interface MyView(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
- (CGColorRef)red;
- (CGColorRef)green;
@end

@implementation MyView

- (CGImageRef)beach {
  if(beach == NULL) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beach" 
                                                     ofType:@"jpg"];
    NSURL *beachURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)beachURL, NULL);
    if(NULL != src) {
      beach = CGImageSourceCreateImageAtIndex(src, 0, NULL); 
      CFRelease(src);
    }
  }
  return beach;
}

- (CALayer *)photoLayer {
  if(nil == photoLayer) {
    photoLayer = [CALayer layer];
    photoLayer.contents = (id)self.beach; 
    photoLayer.bounds = CGRectMake(0.0f, 0.0f, 280.0f, 210.0f);
    photoLayer.position = CGPointMake(NSMidX([self bounds]),
                                      NSMidY([self bounds]));
    photoLayer.name = @"photo";
    [self.layer addSublayer:photoLayer];
  }
  return photoLayer;
}

- (void)bounce {
  [self.photoLayer addAnimation:self.positionAnimation 
   forKey:@"position"];
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  self.layer.backgroundColor = [self black];
  [self setWantsLayer:YES];
  [self photoLayer];
}

- (IBAction)stop:(id)sender {
  [self.photoLayer removeAnimationForKey:@"position"];
}

- (IBAction)moveTopRight:(id)sender {
  [CATransaction begin];
  [CATransaction setValue:[NSNumber numberWithFloat:1.0f]
                   forKey:kCATransactionAnimationDuration];
  [self.photoLayer setPosition:CGPointMake(NSMaxX([self bounds]) - 35.0f, NSMaxY([self bounds]) - 35.0f)];
  [CATransaction commit];
}
- (IBAction)moveBottomLeft:(id)sender {
  [CATransaction begin];
  [CATransaction setValue:[NSNumber numberWithFloat:1.0f]
                   forKey:kCATransactionAnimationDuration];
  [self.photoLayer setPosition:CGPointMake(35.0f, 35.0f)];
  [CATransaction commit];
}

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (CGPathRef)heartPath {
  CGPoint position = [photoLayer position];
  if(heartPath == NULL) {
    CGFloat offset = 50.0f;
    heartPath = CGPathCreateMutable();
    CGPathMoveToPoint(heartPath, NULL, position.x, position.y);
    CGPathAddLineToPoint(heartPath, NULL, position.x - offset, 
                         position.y + offset);
    CGPathAddLineToPoint(heartPath, NULL, position.x, 
                         position.y - 2.0f * offset);
    CGPathAddLineToPoint(heartPath, NULL, position.x + offset, 
                         position.y + offset);
    CGPathAddLineToPoint(heartPath, NULL, position.x, position.y);
    CGPathCloseSubpath(heartPath);
  }
  return heartPath;
}    
- (CAKeyframeAnimation *)positionAnimation { 
  if(nil == positionAnimation) {
    positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.path = self.heartPath;
    positionAnimation.duration = 2.0f;
    positionAnimation.calculationMode = kCAAnimationPaced;
    [positionAnimation retain];
  }
  return positionAnimation;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)event {
  [self bounce];
}

- (void)mouseDown:(NSEvent *)event {
  NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
  CALayer *presLayer = [self.photoLayer presentationLayer];
  CALayer *layer = [presLayer hitTest:NSPointToCGPoint(point)]; 
  if([layer.name isEqualToString:@"photo"]) {
    NSBeep();
  }
}

@end

@implementation MyView (Color)

- (CGColorSpaceRef)genericRGBSpace {
  static CGColorSpaceRef space = NULL;
  if(NULL == space) {
    space = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
  }
  return space;
}

- (CGColorRef)black {
  static CGColorRef black = NULL;
  if(black == NULL) {
    CGFloat values[4] = {0.0, 0.0, 0.0, 1.0};
    black = CGColorCreate([self genericRGBSpace], values);
  }
  return black;
}

- (CGColorRef)white{
  static CGColorRef white = NULL;
  if(white == NULL) {
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
    white = CGColorCreate([self genericRGBSpace], values);
  }
  return white;
}

- (CGColorRef)blue {
  static CGColorRef blue = NULL;
  if(blue == NULL) {
    CGFloat values[4] = {0.0, 0.0, 1.0, 1.0};
    blue = CGColorCreate([self genericRGBSpace], values);
  }
  return blue;
}

- (CGColorRef)red {
  static CGColorRef red = NULL;
  if(red == NULL) {
    CGFloat values[4] = {1.0, 0.0, 0.0, 1.0};
    red = CGColorCreate([self genericRGBSpace], values);
  }
  return red;
}

- (CGColorRef)green {
  static CGColorRef green = NULL;
  if(green == NULL) {
    CGFloat values[4] = {0.0, 1.0, 0.0, 1.0};
    green = CGColorCreate([self genericRGBSpace], values);
  }
  return green;
}

@end
